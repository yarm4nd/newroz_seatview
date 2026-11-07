import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants.dart';
import '../core/exceptions.dart';
import '../models/seat.dart';
import '../models/ticket.dart';
import '../services/database_service.dart';

/// Holds the booking state: sold seats, current selection and tickets.
class BookingProvider extends ChangeNotifier {
  BookingProvider(this._db);

  final DatabaseService _db;
  final Random _random = Random();

  bool _isLoading = false;
  String? _error;
  List<Ticket> _tickets = const [];
  Set<String> _bookedKeys = <String>{};
  final Map<String, Seat> _selected = <String, Seat>{};

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Ticket> get tickets => List.unmodifiable(_tickets);

  /// Selected seats, ordered by section, row and number.
  List<Seat> get selectedSeats {
    final seats = _selected.values.toList()
      ..sort((a, b) {
        final bySection = a.sectionId.compareTo(b.sectionId);
        if (bySection != 0) return bySection;
        final byRow = a.row.compareTo(b.row);
        return byRow != 0 ? byRow : a.number.compareTo(b.number);
      });
    return seats;
  }

  int get selectedCount => _selected.length;

  int get totalPrice =>
      _selected.values.fold(0, (sum, seat) => sum + seat.section.price);

  Future<void> init() async {
    await _run(_reload);
  }

  /// All seats of [section] with their current status.
  List<Seat> seatsFor(StadiumSection section) {
    return [
      for (var row = 1; row <= section.rows; row++)
        for (var number = 1; number <= section.seatsPerRow; number++)
          _seatAt(section.id, row, number),
    ];
  }

  int availableCount(StadiumSection section) {
    final prefix = '${section.id}-';
    final booked = _bookedKeys.where((key) => key.startsWith(prefix)).length;
    return section.capacity - booked;
  }

  int selectedCountIn(StadiumSection section) =>
      _selected.values.where((seat) => seat.sectionId == section.id).length;

  /// Selects or unselects [seat].
  ///
  /// Returns `false` when the seat can't be selected (already sold, or the
  /// per-order limit was reached).
  bool toggleSeat(Seat seat) {
    if (_bookedKeys.contains(seat.key)) return false;

    if (_selected.remove(seat.key) != null) {
      notifyListeners();
      return true;
    }
    if (_selected.length >= AppConstants.maxSeatsPerBooking) return false;

    _selected[seat.key] = seat.copyWith(status: SeatStatus.selected);
    notifyListeners();
    return true;
  }

  void removeSelected(String seatKey) {
    if (_selected.remove(seatKey) != null) notifyListeners();
  }

  void clearSelection() {
    if (_selected.isEmpty) return;
    _selected.clear();
    notifyListeners();
  }

  /// Saves the current selection as tickets for the given person.
  ///
  /// Throws [SeatAlreadyBookedException] if a seat was taken meanwhile.
  Future<List<Ticket>> confirmBooking({
    required String name,
    required String phone,
  }) async {
    if (_selected.isEmpty) return const [];

    final now = DateTime.now();
    final batch = _newBatchId(now);
    final seats = selectedSeats;

    final newTickets = [
      for (var i = 0; i < seats.length; i++)
        Ticket(
          code: 'NZ-$batch-${i + 1}',
          sectionId: seats[i].sectionId,
          row: seats[i].row,
          seatNumber: seats[i].number,
          price: seats[i].section.price,
          holderName: name.trim(),
          phone: phone.replaceAll(RegExp(r'[\s-]'), ''),
          createdAt: now,
        ),
    ];

    try {
      await _db.insertTickets(newTickets);
    } on SeatAlreadyBookedException {
      await _reload();
      _selected.removeWhere((key, _) => _bookedKeys.contains(key));
      notifyListeners();
      rethrow;
    }

    _selected.clear();
    await _reload();
    notifyListeners();
    return newTickets;
  }

  Future<void> cancelTicket(Ticket ticket) async {
    final id = ticket.id;
    if (id == null) return;
    await _run(() async {
      await _db.deleteTicket(id);
      await _reload();
    });
  }

  Seat _seatAt(String sectionId, int row, int number) {
    final key = Seat.buildKey(sectionId, row, number);
    final selected = _selected[key];
    if (selected != null) return selected;
    return Seat(
      sectionId: sectionId,
      row: row,
      number: number,
      status:
          _bookedKeys.contains(key) ? SeatStatus.booked : SeatStatus.available,
    );
  }

  String _newBatchId(DateTime now) {
    final time = now.millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    final salt = _random.nextInt(1296).toRadixString(36).toUpperCase();
    return '$time$salt';
  }

  Future<void> _reload() async {
    _tickets = await _db.getTickets();
    _bookedKeys = _tickets.map((ticket) => ticket.seatKey).toSet();
  }

  Future<void> _run(Future<void> Function() action) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await action();
    } catch (error) {
      _error = 'Something went wrong. Please try again.';
      debugPrint('BookingProvider error: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
