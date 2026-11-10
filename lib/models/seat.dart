import 'package:flutter/material.dart';

import 'ticket_package.dart';

/// Visual/booking state of a seat.
enum SeatStatus { available, booked, selected }

/// One zone of the stadium (A, B, M1 ...). Total capacity: 13,500 seats.
///
/// Edit [all] to change a zone's package or size.
@immutable
class StadiumSection {
  const StadiumSection({
    required this.id,
    required this.side,
    required this.package,
    required this.rows,
    required this.seatsPerRow,
  });

  final String id;

  /// 'north', 'east', 'south' or 'west' (used for 360° photos).
  final String side;
  final TicketPackage package;
  final int rows;
  final int seatsPerRow;

  String get name => 'Zone $id';
  int get price => package.price;
  Color get color => package.color;
  int get capacity => rows * seatsPerRow;

  static const List<StadiumSection> all = [
    // North side (top of the map)
    StadiumSection(
        id: 'L',
        side: 'north',
        package: TicketPackage.basic,
        rows: 9,
        seatsPerRow: 26),
    StadiumSection(
        id: 'M',
        side: 'north',
        package: TicketPackage.standard,
        rows: 14,
        seatsPerRow: 35),
    StadiumSection(
        id: 'M1',
        side: 'north',
        package: TicketPackage.standard,
        rows: 8,
        seatsPerRow: 16),
    StadiumSection(
        id: 'N',
        side: 'north',
        package: TicketPackage.family,
        rows: 18,
        seatsPerRow: 46),
    StadiumSection(
        id: 'N1',
        side: 'north',
        package: TicketPackage.family,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'O',
        side: 'north',
        package: TicketPackage.family,
        rows: 18,
        seatsPerRow: 47),
    StadiumSection(
        id: 'O1',
        side: 'north',
        package: TicketPackage.family,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'P',
        side: 'north',
        package: TicketPackage.standard,
        rows: 18,
        seatsPerRow: 47),
    StadiumSection(
        id: 'P1',
        side: 'north',
        package: TicketPackage.standard,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'Q',
        side: 'north',
        package: TicketPackage.standard,
        rows: 14,
        seatsPerRow: 36),
    StadiumSection(
        id: 'R',
        side: 'north',
        package: TicketPackage.basic,
        rows: 9,
        seatsPerRow: 26),
    // East side (right of the map)
    StadiumSection(
        id: 'S',
        side: 'east',
        package: TicketPackage.basic,
        rows: 12,
        seatsPerRow: 30),
    StadiumSection(
        id: 'S1',
        side: 'east',
        package: TicketPackage.basic,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'T',
        side: 'east',
        package: TicketPackage.basic,
        rows: 16,
        seatsPerRow: 42),
    StadiumSection(
        id: 'U',
        side: 'east',
        package: TicketPackage.basic,
        rows: 16,
        seatsPerRow: 42),
    StadiumSection(
        id: 'U1',
        side: 'east',
        package: TicketPackage.basic,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'V',
        side: 'east',
        package: TicketPackage.basic,
        rows: 12,
        seatsPerRow: 30),
    // South side (bottom of the map)
    StadiumSection(
        id: 'W',
        side: 'south',
        package: TicketPackage.basic,
        rows: 9,
        seatsPerRow: 26),
    StadiumSection(
        id: 'A',
        side: 'south',
        package: TicketPackage.standard,
        rows: 14,
        seatsPerRow: 36),
    StadiumSection(
        id: 'A1',
        side: 'south',
        package: TicketPackage.standard,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'B',
        side: 'south',
        package: TicketPackage.standard,
        rows: 18,
        seatsPerRow: 47),
    StadiumSection(
        id: 'B1',
        side: 'south',
        package: TicketPackage.vip,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'C',
        side: 'south',
        package: TicketPackage.vip,
        rows: 10,
        seatsPerRow: 27),
    StadiumSection(
        id: 'D',
        side: 'south',
        package: TicketPackage.vip,
        rows: 9,
        seatsPerRow: 23),
    StadiumSection(
        id: 'D1',
        side: 'south',
        package: TicketPackage.vip,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'E',
        side: 'south',
        package: TicketPackage.vip,
        rows: 18,
        seatsPerRow: 47),
    StadiumSection(
        id: 'E1',
        side: 'south',
        package: TicketPackage.standard,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'F',
        side: 'south',
        package: TicketPackage.standard,
        rows: 14,
        seatsPerRow: 36),
    StadiumSection(
        id: 'G',
        side: 'south',
        package: TicketPackage.basic,
        rows: 9,
        seatsPerRow: 26),
    // West side (left of the map)
    StadiumSection(
        id: 'H',
        side: 'west',
        package: TicketPackage.basic,
        rows: 12,
        seatsPerRow: 30),
    StadiumSection(
        id: 'H1',
        side: 'west',
        package: TicketPackage.basic,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'I',
        side: 'west',
        package: TicketPackage.basic,
        rows: 16,
        seatsPerRow: 42),
    StadiumSection(
        id: 'J',
        side: 'west',
        package: TicketPackage.basic,
        rows: 16,
        seatsPerRow: 42),
    StadiumSection(
        id: 'J1',
        side: 'west',
        package: TicketPackage.basic,
        rows: 7,
        seatsPerRow: 21),
    StadiumSection(
        id: 'K',
        side: 'west',
        package: TicketPackage.basic,
        rows: 12,
        seatsPerRow: 30),
  ];

  static final Map<String, StadiumSection> _byId = {
    for (final zone in all) zone.id: zone,
  };

  static StadiumSection byId(String id) {
    final zone = _byId[id];
    if (zone == null) throw StateError('Unknown zone "$id"');
    return zone;
  }

  static List<StadiumSection> inPackage(TicketPackage package) =>
      all.where((zone) => zone.package == package).toList();

  /// Sum of every zone. Must equal `AppConstants.stadiumCapacity`.
  static int get totalCapacity =>
      all.fold(0, (sum, zone) => sum + zone.capacity);
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

  /// Unique identifier, e.g. `M1-3-7`.
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
