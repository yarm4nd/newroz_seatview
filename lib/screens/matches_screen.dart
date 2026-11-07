import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/theme.dart';
import '../data/iraq_league_fixtures.dart';
import '../models/league_match.dart';

enum _Filter { all, newroz }

/// All published Iraq Stars League matches, grouped by day.
class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  _Filter _filter = _Filter.all;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matches = IraqLeagueFixtures.all
        .where((match) => _filter == _Filter.all || match.involvesNewroz)
        .toList();
    final items = _flatten(matches);

    return Scaffold(
      appBar: AppBar(title: const Text('Iraq Stars League 2026–27')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: SegmentedButton<_Filter>(
                  segments: const [
                    ButtonSegment(
                      value: _Filter.all,
                      label: Text('All matches'),
                      icon: Icon(Icons.sports_soccer),
                    ),
                    ButtonSegment(
                      value: _Filter.newroz,
                      label: Text('Newroz'),
                      icon: Icon(Icons.local_fire_department),
                    ),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (selection) =>
                      setState(() => _filter = selection.first),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '${matches.length} matches',
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) return const _FooterNote();
                    final item = items[index];
                    if (item is DateTime) return _DayHeader(day: item);
                    return _MatchCard(match: item as LeagueMatch);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A day header (DateTime) before the matches of that day.
  List<Object> _flatten(List<LeagueMatch> matches) {
    final items = <Object>[];
    DateTime? currentDay;
    for (final match in matches) {
      if (currentDay != match.day) {
        currentDay = match.day;
        items.add(currentDay);
      }
      items.add(match);
    }
    return items;
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day});

  final DateTime day;

  String get _label {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final text = DateFormat('EEEE, d MMMM y').format(day);
    final diff = day.difference(today).inDays;
    if (diff == 0) return 'Today • $text';
    if (diff == 1) return 'Tomorrow • $text';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({required this.match});

  final LeagueMatch match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = match.involvesNewroz;
    final time =
        match.timeConfirmed ? DateFormat('HH:mm').format(match.kickoff) : 'TBC';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      color: highlight
          ? AppColors.fire.withValues(alpha: 0.08)
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: highlight ? AppColors.fire : theme.colorScheme.outlineVariant,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _TeamName(name: match.home, align: TextAlign.right),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    time,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: _TeamName(name: match.away, align: TextAlign.left),
                ),
              ],
            ),
            if (match.isNewrozHome) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.stadium_outlined,
                    size: 16,
                    color: AppColors.fire,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Newroz Stadium, Sulaymaniyah',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.fire,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TeamName extends StatelessWidget {
  const _TeamName({required this.name, required this.align});

  final String name;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final isNewroz = name == LeagueMatch.newroz;
    return Text(
      name,
      textAlign: align,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: isNewroz ? FontWeight.w800 : FontWeight.w500,
          ),
    );
  }
}

class _FooterNote extends StatelessWidget {
  const _FooterNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Text(
        'Only the rounds announced so far are shown. '
        'Kick-off times marked TBC are not confirmed yet.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
