import 'package:flutter/material.dart';

/// Visual/booking state of a seat.
enum SeatStatus { available, booked, selected }

/// A block of seats in the stadium (one stand).
@immutable
class StadiumSection {
  const StadiumSection({
    required this.id,
    required this.name,
    required this.rows,
    required this.seatsPerRow,
    required this.price,
    required this.color,
  });

  final String id;
  final String name;
  final int rows;
  final int seatsPerRow;

  /// Ticket price in IQD.
  final int price;
  final Color color;

  int get capacity => rows * seatsPerRow;

  static const StadiumSection north = StadiumSection(
    id: 'N',
    name: 'North Stand',
    rows: 8,
    seatsPerRow: 12,
    price: 10000,
    color: Color(0xFF1C7ED6),
  );

  static const StadiumSection south = StadiumSection(
    id: 'S',
    name: 'South Stand',
    rows: 8,
    seatsPerRow: 12,
    price: 10000,
    color: Color(0xFF7048E8),
  );

  static const StadiumSection east = StadiumSection(
    id: 'E',
    name: 'East Stand',
    rows: 8,
    seatsPerRow: 12,
    price: 15000,
    color: Color(0xFFE8590C),
  );

  static const StadiumSection west = StadiumSection(
    id: 'W',
    name: 'West Stand (VIP)',
    rows: 6,
    seatsPerRow: 12,
    price: 25000,
    color: Color(0xFFC92A2A),
  );

  static const List<StadiumSection> all = [north, east, south, west];

  static StadiumSection byId(String id) =>
      all.firstWhere((section) => section.id == id);
}

/// A single seat in a [StadiumSection].
@immutable
class Seat {
  const Seat({
    required this.sectionId,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
  });

  final String sectionId;
  final int row;
  final int number;
  final SeatStatus status;

  /// Unique identifier, e.g. `N-3-7`.
  String get key => buildKey(sectionId, row, number);

  String get label => 'Row $row, Seat $number';

  StadiumSection get section => StadiumSection.byId(sectionId);

  bool get isBooked => status == SeatStatus.booked;
  bool get isSelected => status == SeatStatus.selected;

  static String buildKey(String sectionId, int row, int number) =>
      '$sectionId-$row-$number';

  Seat copyWith({SeatStatus? status}) => Seat(
        sectionId: sectionId,
        row: row,
        number: number,
        status: status ?? this.status,
      );

  @override
  bool operator ==(Object other) =>
      other is Seat && other.key == key && other.status == status;

  @override
  int get hashCode => Object.hash(key, status);
}
