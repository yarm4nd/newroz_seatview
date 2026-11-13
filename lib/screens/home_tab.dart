import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/constants.dart';
import '../core/formatters.dart';
import '../core/theme.dart';
import '../core/translator.dart';
import '../models/league_match.dart';
import '../models/membership_tier.dart';
import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/membership_provider.dart';
import '../widgets/product_art.dart';
import '../widgets/team_crest.dart';
import 'news_screen.dart';
import 'squad_screen.dart';
import 'stadium_screen.dart';
import 'tickets_screen.dart';

final DateFormat _dayFormat = DateFormat('EEE, d MMM');
final DateFormat _timeFormat = DateFormat('HH:mm');

String _when(LeagueMatch match, AppLanguage lang) {
  final time = match.timeConfirmed ? _timeFormat.format(match.kickoff) : Tr.text(lang, 'TBC');
  return '${Tr.text(lang, _dayFormat.format(match.kickoff))} • $time';
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onNavigate});
  final ValueChanged<int> onNavigate;

  void _openBooking(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const StadiumScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tier = context.watch<MembershipProvider>().tierFor(auth.user?.id);
    final lang = context.watch<LocaleProvider>().language;
    final admin = context.watch<AdminProvider>();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final upcoming = admin.matches.where((m) => m.involvesNewroz && !m.day.isBefore(today)).toList();
    final next = upcoming.isEmpty ? null : upcoming.first;
    final later = upcoming.skip(1).take(4).toList();
    final firstName = (auth.user?.name ?? '').trim().split(' ').first;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(name: firstName, tier: tier, lang: lang),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (next != null) _NextMatchCard(match: next, score: admin.scoreFor(next), lang: lang, onBook: () => _openBooking(context)) else const _NoMatchCard(),
                      const SizedBox(height: 16),
                      Row(children: [
                        Expanded(child: _ActionTile(icon: Icons.event_seat, label: AppStrings.of(lang, 'book_seats'), onTap: () => _openBooking(context))),
                        Expanded(child: _ActionTile(icon: Icons.confirmation_number_outlined, label: AppStrings.of(lang, 'my_tickets'), onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const TicketsScreen())))),
                        Expanded(child: _ActionTile(icon: Icons.groups_outlined, label: AppStrings.of(lang, 'squad'), onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const SquadScreen())))),
                        Expanded(child: _ActionTile(icon: Icons.newspaper, label: AppStrings.of(lang, 'news'), onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const NewsScreen())))),
                      ]),
                      if (later.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _SectionHeader(title: AppStrings.of(lang, 'fixtures'), action: AppStrings.of(lang, 'see_all'), onAction: () => onNavigate(1)),
                        for (final match in later) _FixtureTile(match: match, score: admin.scoreFor(match), lang: lang),
                      ],
                      const SizedBox(height: 24),
                      _SectionHeader(title: AppStrings.of(lang, 'latest_news'), action: AppStrings.of(lang, 'see_all'), onAction: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const NewsScreen()))),
                      for (final item in admin.news.take(2)) NewsCard(item: item),
                      const SizedBox(height: 24),
                      _SectionHeader(title: AppStrings.of(lang, 'team_shop'), action: AppStrings.of(lang, 'open_shop'), onAction: () => onNavigate(2)),
                      SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: admin.products.length < 6 ? admin.products.length : 6,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final product = admin.products[index];
                            return GestureDetector(
                              onTap: () => onNavigate(2),
                              child: SizedBox(
                                width: 120,
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Expanded(child: ProductArt(product: product, iconSize: 40)),
                                  const SizedBox(height: 6),
                                  Text(Tr.text(lang, product.name), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                                  Text(Tr.text(lang, Formatters.currency(product.price)), style: Theme.of(context).textTheme.bodySmall),
                                ]),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _MembershipPromo(tier: tier, lang: lang, onTap: () => onNavigate(3)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.tier, required this.lang});
  final String name;
  final MembershipTier? tier;
  final AppLanguage lang;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 24, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF8B0018), Color(0xFFC8102E)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(children: [
        const Icon(Icons.shield, color: Colors.white, size: 38),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(AppStrings.of(lang, 'welcome_back'), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          Text(name.isEmpty ? AppConstants.appName : name, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.workspace_premium, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(tier != null ? Tr.text(lang, tier!.label) : AppStrings.of(lang, 'free_fan'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
          ]),
        ),
      ]),
    );
  }
}

class _NextMatchCard extends StatelessWidget {
  const _NextMatchCard({required this.match, required this.score, required this.lang, required this.onBook});
  final LeagueMatch match;
  final String? score;
  final AppLanguage lang;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: theme.colorScheme.outlineVariant)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Text(AppStrings.of(lang, 'next_match'), style: theme.textTheme.labelMedium?.copyWith(color: AppColors.emerald, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: _Team(name: Tr.text(lang, match.home))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(score ?? 'VS', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: score != null ? AppColors.emerald : theme.colorScheme.outline)),
            ),
            Expanded(child: _Team(name: Tr.text(lang, match.away))),
          ]),
          const SizedBox(height: 16),
          _InfoRow(icon: Icons.calendar_today_outlined, text: _when(match, lang)),
          const SizedBox(height: 8),
          _InfoRow(icon: Icons.location_on_outlined, text: match.isNewrozHome ? Tr.text(lang, AppConstants.venue) : AppStrings.of(lang, 'away_badge')),
          const SizedBox(height: 16),
          if (match.isNewrozHome)
FilledButton.icon(onPressed: onBook, icon: const Icon(Icons.event_seat), label: Text(AppStrings.of(lang, 'book_tickets')))
else
Text('This is an away match.', style: theme.textTheme.bodySmall),
]),
),
);
}
}
class _NoMatchCard extends StatelessWidget {
const _NoMatchCard();
@override
Widget build(BuildContext context) => const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('No upcoming matches.')));
}
class _Team extends StatelessWidget {
const _Team({required this.name});
final String name;
@override
Widget build(BuildContext context) => Column(children: [TeamCrest(name: name, size: 56), const SizedBox(height: 8), Text(name, maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))]);
}
class _InfoRow extends StatelessWidget {
const _InfoRow({required this.icon, required this.text});
final IconData icon;
final String text;
@override
Widget build(BuildContext context) => Row(children: [Icon(icon, size: 18, color: AppColors.emerald), const SizedBox(width: 8), Expanded(child: Text(text))]);
}
class _ActionTile extends StatelessWidget {
const _ActionTile({required this.icon, required this.label, required this.onTap});
final IconData icon;
final String label;
final VoidCallback onTap;
@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
return InkWell(
borderRadius: BorderRadius.circular(16),
onTap: onTap,
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 10),
child: Column(children: [
Container(width: 52, height: 52, decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: theme.colorScheme.primary)),
const SizedBox(height: 6),
Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelMedium),
]),
),
);
}
}
class _SectionHeader extends StatelessWidget {
const _SectionHeader({required this.title, required this.action, required this.onAction});
final String title;
final String action;
final VoidCallback onAction;
@override
Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))), TextButton(onPressed: onAction, child: Text(action))]));
}
class _FixtureTile extends StatelessWidget {
const _FixtureTile({required this.match, required this.score, required this.lang});
final LeagueMatch match;
final String? score;
final AppLanguage lang;
@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final opponent = match.isNewrozHome ? match.away : match.home;
return Card(
elevation: 0,
margin: const EdgeInsets.only(bottom: 8),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant)),
child: ListTile(
leading: TeamCrest(name: opponent, size: 40),
title: Text('${Tr.text(lang, match.home)} ${score ?? 'vs'} ${Tr.text(lang, match.away)}'),
subtitle: Text(_when(match, lang)),
trailing: Text(match.isNewrozHome ? AppStrings.of(lang, 'home_badge') : AppStrings.of(lang, 'away_badge'), style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800, color: match.isNewrozHome ? AppColors.emerald : theme.colorScheme.outline)),
),
);
}
}
class _MembershipPromo extends StatelessWidget {
const _MembershipPromo({required this.tier, required this.lang, required this.onTap});
final MembershipTier? tier;
final AppLanguage lang;
final VoidCallback onTap;
@override
Widget build(BuildContext context) {
final theme = Theme.of(context);
final current = tier;
return Container(
padding: const EdgeInsets.all(20),
decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF7F1D1D), Color(0xFF1F1215)]), borderRadius: BorderRadius.circular(20)),
child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
const Icon(Icons.workspace_premium, color: AppColors.gold, size: 32),
const SizedBox(height: 8),
Text(current == null ? AppStrings.of(lang, 'join_family') : Tr.text(lang, current.label), style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
const SizedBox(height: 4),
Text(AppStrings.of(lang, 'join_desc'), style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
const SizedBox(height: 16),
FilledButton(onPressed: onTap, child: Text(current == null ? AppStrings.of(lang, 'view_plans') : AppStrings.of(lang, 'manage_membership'))),
]),
);
}
}
