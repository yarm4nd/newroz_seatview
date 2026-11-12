import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/theme.dart';
import '../core/translator.dart';
import '../data/iraq_league_fixtures.dart';
import '../models/league_match.dart';
import '../providers/locale_provider.dart';

enum _Filter { all, newroz }

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
    final lang = context.watch<LocaleProvider>().language;
    final matches = IraqLeagueFixtures.all
        .where((match) => _filter == _Filter.all || match.involvesNewroz)
        .toList();
    final items = _flatten(matches);
    final footerNote = lang == AppLanguage.arabic
        ? '\u064A\u062A\u0645 \u0639\u0631\u0636 \u0627\u0644\u062C\u0648\u0644\u0627\u062A \u0627\u0644\u0645\u0639\u0644\u0646\u0629 \u062D\u062A\u0649 \u0627\u0644\u0622\u0646 \u0641\u0642\u0637.'
        : 'Only the rounds announced so far are shown. Kick-off times marked TBC are not confirmed yet.';

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'league_title'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: SegmentedButton<_Filter>(
                  segments: [
                    ButtonSegment(value: _Filter.all, label: Text(AppStrings.of(lang, 'all_matches')), icon: const Icon(Icons.sports_soccer)),
                    ButtonSegment(value: _Filter.newroz, label: Text(AppStrings.of(lang, 'newroz')), icon: const Icon(Icons.local_fire_department)),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (selection) => setState(() => _filter = selection.first),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text('${matches.length} ${AppStrings.of(lang, 'matches_count')}', style: theme.textTheme.bodySmall),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == items.length) {
                      return Padding(padding: const EdgeInsets.only(top: 20), child: Text(footerNote, textAlign: TextAlign.center, style: theme.textTheme.bodySmall));
                    }
                    final item = items[index];
                    if (item is DateTime) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                        child: Text(Tr.text(lang, DateFormat('EEEE, d MMMM y').format(item)), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                      );
                    }
                    final match = item as LeagueMatch;
                    final highlight = match.involvesNewroz;
                    final time = match.timeConfirmed ? DateFormat('HH:mm').format(match.kickoff) : Tr.text(lang, 'TBC');
                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 8),
                      color: highlight ? AppColors.emerald.withValues(alpha: 0.08) : theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: highlight ? AppColors.emerald : theme.colorScheme.outlineVariant)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Column(children: [
                          Row(children: [
                            Expanded(child: Text(Tr.text(lang, match.home), textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w700))),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text(time, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))),
                            Expanded(child: Text(Tr.text(lang, match.away), textAlign: TextAlign.start, style: const TextStyle(fontWeight: FontWeight.w700))),
                          ]),
                          if (match.isNewrozHome) ...[
                            const SizedBox(height: 8),
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              const Icon(Icons.stadium_outlined, size: 16, color: AppColors.emerald),
                              const SizedBox(width: 6),
                              Text(Tr.text(lang, 'Newroz Stadium, Sulaymaniyah'), style: theme.textTheme.bodySmall?.copyWith(color: AppColors.emerald, fontWeight: FontWeight.w600)),
                            ]),
                          ],
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
