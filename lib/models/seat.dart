import 'package:flutter/material.dart';

/// Visual/booking state of a seat.
enum SeatStatus { available, booked, selected }

/// One block of seats inside a stand, e.g. "North Stand – Block 2".
///
/// Layout: 4 stands x 3 blocks x 25 rows x 45 seats = 13,500 seats.
@immutable
class StadiumSection {
  const StadiumSection({
    required this.id,
    required this.stand,
    required this.block,
    required this.rows,
    required this.seatsPerRow,
    required this.price,
    required this.color,
  });

  /// Short id such as `N2`.
  final String id;
  final String stand;
  final int block;
  final int rows;
  final int seatsPerRow;

  /// Ticket price in IQD.
  final int price;
  final Color color;

  String get name => '$stand – Block $block';

  int get capacity => rows * seatsPerRow;

  static const int _blocksPerStand = 3;
  static const int _blockRows = 25;
  static const int _blockSeatsPerRow = 45;

  static List<StadiumSection> _buildStand({
    required String letter,
    required String stand,
    required int price,
    required Color color,
  }) {
    return [
      for (var i = 1; i <= _blocksPerStand; i++)
        StadiumSection(
          id: '$letter$i',
          stand: stand,
          block: i,
          rows: _blockRows,
          seatsPerRow: _blockSeatsPerRow,
          price: price,
          color: color,
        ),
    ];
  }

  static final List<StadiumSection> north = _buildStand(
    letter: 'N',
    stand: 'North Stand',
    price: 10000,
    color: const Color(0xFF1C7ED6),
  );

  static final List<StadiumSection> east = _buildStand(
    letter: 'E',
    stand: 'East Stand',
    price: 15000,
    color: const Color(0xFFE8590C),
  );

  static final List<StadiumSection> south = _buildStand(
    letter: 'S',
    stand: 'South Stand',
    price: 10000,
    color: const Color(0xFF7048E8),
  );

  static final List<StadiumSection> west = _buildStand(
    letter: 'W',
    stand: 'West VIP Stand',
    price: 25000,
    color: const Color(0xFFC92A2A),
  );

  static final List<StadiumSection> all = [
    ...north,
    ...east,
    ...south,
    ...west
  ];

  static const List<String> stands = [
    'North Stand',
    'East Stand',
    'South Stand',
    'West VIP Stand',
  ];

  static final Map<String, StadiumSection> _byId = {
    for (final section in all) section.id: section,
  };

  static StadiumSection byId(String id) {
    final section = _byId[id];
    if (section == null) throw StateError('Unknown section "$id"');
    return section;
  }

  static List<StadiumSection> inStand(String stand) =>
      all.where((section) => section.stand == stand).toList();

  /// Sum of every block. Must equal `AppConstants.stadiumCapacity`.
  static int get totalCapacity =>
      all.fold(0, (sum, section) => sum + section.capacity);
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

  /// Unique identifier, e.g. `N2-3-7`.
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
