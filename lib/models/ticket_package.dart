import 'package:flutter/material.dart';

/// The four ticket packages. Edit prices and texts here.
enum TicketPackage {
  vip(
    label: 'VIP Experience',
    price: 25000,
    description: 'Premium seats with access to the VIP lounge.',
    color: Color(0xFFD9A400),
  ),
  standard(
    label: 'Standard Package',
    price: 5000,
    description: 'Great seats with an excellent view of the stadium.',
    color: Color(0xFF2B8A3E),
  ),
  family(
    label: 'Family Package',
    price: 5000,
    description:
        'Families only. Single men are asked not to buy tickets in this zone.',
    color: Color(0xFF3B82C4),
  ),
  basic(
    label: 'Basic Package',
    price: 3000,
    description: 'Seats behind the goals.',
    color: Color(0xFFC92A2A),
  );

  const TicketPackage({
    required this.label,
    required this.price,
    required this.description,
    required this.color,
  });

  final String label;

  /// Ticket price in IQD.
  final int price;
  final String description;
  final Color color;
}
