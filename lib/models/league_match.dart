import 'package:flutter/foundation.dart';

/// One Iraq Stars League game.
@immutable
class LeagueMatch {
  const LeagueMatch({
    required this.home,
    required this.away,
    required this.kickoff,
    this.timeConfirmed = true,
  });

  /// Our club, as spelled in the fixtures list.
  static const String newroz = 'Newroz';

  final String home;
  final String away;

  /// When [timeConfirmed] is false only the date is meaningful.
  final DateTime kickoff;
  final bool timeConfirmed;

  bool get involvesNewroz => home == newroz || away == newroz;
  bool get isNewrozHome => home == newroz;

  /// Kickoff date without the time of day.
  DateTime get day => DateTime(kickoff.year, kickoff.month, kickoff.day);
}
