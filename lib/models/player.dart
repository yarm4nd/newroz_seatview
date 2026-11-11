import 'package:flutter/material.dart';

enum PlayerPosition {
  goalkeeper('Goalkeepers', Color(0xFFC77700)),
  defender('Defenders', Color(0xFF1C7ED6)),
  midfielder('Midfielders', Color(0xFF2B8A3E)),
  forward('Forwards', Color(0xFFC92A2A));

  const PlayerPosition(this.label, this.color);

  final String label;
  final Color color;
}

class Player {
  const Player({
    required this.number,
    required this.name,
    required this.position,
  });

  final int number;
  final String name;
  final PlayerPosition position;
}
