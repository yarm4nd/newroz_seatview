import 'package:flutter/foundation.dart';

import 'seat.dart';

/// A purchased ticket for one seat.
@immutable
class Ticket {
  const Ticket({
    required this.code,
    required this.sectionId,
    required this.row,
    required this.seatNumber,
    required this.price,
    required this.holderName,
    required this.phone,
    required this.createdAt,
    this.id,
  });

  final int? id;
  final String code;
  final String sectionId;
  final int row;
  final int seatNumber;
  final int price;
  final String holderName;
  final String phone;
  final DateTime createdAt;

  String get seatKey => Seat.buildKey(sectionId, row, seatNumber);

  StadiumSection get section => StadiumSection.byId(sectionId);

  Map<String, Object?> toMap() => {
        if (id != null) 'id': id,
        'code': code,
        'section_id': sectionId,
        'seat_row': row,
        'seat_number': seatNumber,
        'price': price,
        'holder_name': holderName,
        'phone': phone,
        'created_at': createdAt.millisecondsSinceEpoch,
      };

  factory Ticket.fromMap(Map<String, Object?> map) => Ticket(
        id: map['id'] as int?,
        code: map['code']! as String,
        sectionId: map['section_id']! as String,
        row: map['seat_row']! as int,
        seatNumber: map['seat_number']! as int,
        price: map['price']! as int,
        holderName: map['holder_name']! as String,
        phone: map['phone']! as String,
        createdAt:
            DateTime.fromMillisecondsSinceEpoch(map['created_at']! as int),
      );
}
