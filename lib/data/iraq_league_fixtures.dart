import '../models/league_match.dart';

/// Iraq Stars League 2026–27 fixtures published so far.
///
/// Sources: futbol24.com (8 Nov – 25 Dec) and soccerway.com (7 Nov).
/// More rounds will be added here when they are announced.
class IraqLeagueFixtures {
  const IraqLeagueFixtures._();

  static final List<LeagueMatch> all = _build();

  static List<LeagueMatch> _build() {
    final list = <LeagueMatch>[
      // Opening matches (no kickoff time published yet).
      _m(11, 7, 'Quwa Al Jawiya', 'Karkh'),
      _m(11, 7, "Zawra'a Baghdad", 'Al Jolan'),
      _m(11, 8, 'Erbil', 'Al Gharraf', '14:30'),
      _m(11, 8, 'Shorta Baghdad', 'Naft Baghdad', '17:00'),

      // 19 – 21 November
      _m(11, 19, 'Duhok', 'Erbil', '14:00'),
      _m(11, 19, 'Kahraba Baghdad', 'Diyala', '14:45'),
      _m(11, 19, 'Al Gharraf', 'Quwa Al Jawiya', '16:30'),
      _m(11, 19, 'Ghaz Al Shamal', 'Karkh', '17:00'),
      _m(11, 20, 'Zakho', 'Shorta Baghdad', '14:00'),
      _m(11, 20, "Mina'a Basra", 'Karbala', '15:00'),
      _m(11, 20, "Zawra'a Baghdad", 'Talaba Baghdad', '16:30'),
      _m(11, 20, 'Al Jolan', 'Naft Baghdad', '17:15'),
      _m(11, 21, 'Newroz', 'Al Karma', '14:00'),
      _m(11, 21, 'Naft Maysan', 'Mosul', '16:30'),

      // 27 – 29 November
      _m(11, 27, 'Talaba Baghdad', "Mina'a Basra", '14:00'),
      _m(11, 27, 'Zakho', 'Karbala', '14:30'),
      _m(11, 27, 'Ghaz Al Shamal', 'Al Karma', '16:30'),
      _m(11, 27, 'Al Gharraf', 'Mosul', '17:00'),
      _m(11, 28, 'Duhok', 'Diyala', '14:00'),
      _m(11, 28, 'Newroz', 'Kahraba Baghdad', '14:45'),
      _m(11, 28, 'Naft Baghdad', 'Quwa Al Jawiya', '16:30'),
      _m(11, 29, 'Karkh', "Zawra'a Baghdad", '15:00'),
      _m(11, 29, 'Al Jolan', 'Erbil', '16:30'),
      _m(11, 29, 'Naft Maysan', 'Shorta Baghdad', '17:30'),

      // 3 – 5 December
      _m(12, 3, 'Quwa Al Jawiya', 'Zakho', '14:00'),
      _m(12, 3, 'Mosul', "Mina'a Basra", '15:30'),
      _m(12, 4, 'Erbil', "Zawra'a Baghdad", '14:00'),
      _m(12, 4, 'Talaba Baghdad', 'Al Gharraf', '14:45'),
      _m(12, 4, 'Shorta Baghdad', 'Duhok', '16:30'),
      _m(12, 4, 'Al Karma', 'Al Jolan', '17:00'),
      _m(12, 5, 'Diyala', 'Karkh', '14:00'),
      _m(12, 5, 'Kahraba Baghdad', 'Naft Maysan', '14:45'),
      _m(12, 5, 'Karbala', 'Ghaz Al Shamal', '16:30'),
      _m(12, 5, 'Naft Baghdad', 'Newroz', '17:00'),

      // 11 December (kickoff times not confirmed)
      _m(12, 11, 'Al Gharraf', 'Zakho'),
      _m(12, 11, 'Al Jolan', 'Karbala'),
      _m(12, 11, 'Al Karma', 'Talaba Baghdad'),
      _m(12, 11, 'Erbil', 'Naft Baghdad'),
      _m(12, 11, 'Diyala', 'Shorta Baghdad'),
      _m(12, 11, 'Duhok', 'Naft Maysan'),
      _m(12, 11, 'Karkh', "Mina'a Basra"),
      _m(12, 11, 'Mosul', 'Ghaz Al Shamal'),
      _m(12, 11, 'Quwa Al Jawiya', 'Kahraba Baghdad'),
      _m(12, 11, "Zawra'a Baghdad", 'Newroz'),

      // 25 December (8 of 10 matches published so far)
      _m(12, 25, 'Ghaz Al Shamal', 'Naft Baghdad'),
      _m(12, 25, 'Kahraba Baghdad', 'Mosul'),
      _m(12, 25, 'Karbala', 'Diyala'),
      _m(12, 25, "Mina'a Basra", 'Al Jolan'),
      _m(12, 25, 'Naft Maysan', 'Al Gharraf'),
      _m(12, 25, 'Newroz', 'Karkh'),
      _m(12, 25, 'Shorta Baghdad', 'Quwa Al Jawiya'),
      _m(12, 25, 'Talaba Baghdad', 'Erbil'),
    ];

    list.sort((a, b) {
      final byTime = a.kickoff.compareTo(b.kickoff);
      return byTime != 0 ? byTime : a.home.compareTo(b.home);
    });
    return List.unmodifiable(list);
  }
}

/// Builds a 2026 match. Leave [time] out when the kickoff is not confirmed.
LeagueMatch _m(
  int month,
  int day,
  String home,
  String away, [
  String? time,
]) {
  if (time == null) {
    return LeagueMatch(
      home: home,
      away: away,
      kickoff: DateTime(2026, month, day),
      timeConfirmed: false,
    );
  }
  final parts = time.split(':');
  return LeagueMatch(
    home: home,
    away: away,
    kickoff: DateTime(
      2026,
      month,
      day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    ),
  );
}
