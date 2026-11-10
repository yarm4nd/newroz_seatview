import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/league_match.dart';

/// Round badge with the team's initials (replace with real logos later).
class TeamCrest extends StatelessWidget {
  const TeamCrest({super.key, required this.name, this.size = 44});

  final String name;
  final double size;

  static const List<Color> _palette = [
    Color(0xFF1C7ED6),
    Color(0xFF2B8A3E),
    Color(0xFF7048E8),
    Color(0xFFC92A2A),
    Color(0xFF0B7285),
    Color(0xFFC77700),
    Color(0xFF495057),
  ];

  String get _initials {
    final words =
        name.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) {
      final word = words.first;
      return word.substring(0, word.length < 2 ? 1 : 2).toUpperCase();
    }
    return (words[0][0] + words[1][0]).toUpperCase();
  }

  Color get _color {
    if (name == LeagueMatch.newroz) return AppColors.fire;
    var hash = 0;
    for (final unit in name.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return _palette[hash % _palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
      child: Text(
        _initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.36,
        ),
      ),
    );
  }
}
