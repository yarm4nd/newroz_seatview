import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../core/theme.dart';
import '../data/iraq_league_fixtures.dart';
import '../data/shop_products.dart';
import '../models/league_match.dart';
import '../models/membership_tier.dart';
import '../providers/auth_provider.dart';
import '../providers/membership_provider.dart';
import '../widgets/product_art.dart';
import '../widgets/team_crest.dart';
import 'stadium_screen.dart';
import 'tickets_screen.dart';

final DateFormat _dayFormat = DateFormat('EEE, d MMM');
final DateFormat _timeFormat = DateFormat('HH:mm');

String _when(LeagueMatch match) {
  final time =
      match.timeConfirmed ? _timeFormat.format(match.kickoff) : 'Time TBC';
  return '${_dayFormat.format(match.kickoff)} • $time';
}

/// Dashboard: next Newroz match, quick actions, fixtures, shop and membership.
class HomeTab extends StatelessWidget {
  const HomeTab({super.key, required this.onNavigate});

  /// Switches the bottom navigation tab (1 matches, 2 shop, 3 membership).
  final ValueChanged<int> onNavigate;

  void _openBooking(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const StadiumScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final tier = context.watch<MembershipProvider>().tierFor(auth.user?.id);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final upcoming = IraqLeagueFixtures.all
        .where((m) => m.involvesNewroz && !m.day.isBefore(today))
        .toList();
    final next = upcoming.isEmpty ? null : upcoming.first;
    final later = upcoming.skip(1).take(4).toList();
    final firstName = (auth.user?.name ?? '').trim().split(' ').first;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(name: firstName, tier: tier),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (next != null)
                        _NextMatchCard(
                          match: next,
                          onBook: () => _openBooking(context),
                        )
                      else
                        const _NoMatchCard(),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.event_seat,
                              label: 'Book seats',
                              onTap: () => _openBooking(context),
                            ),
                          ),
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.confirmation_number_outlined,
                              label: 'My tickets',
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const TicketsScreen(),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.storefront_outlined,
                              label: 'Shop',
                              onTap: () => onNavigate(2),
                            ),
                          ),
                          Expanded(
                            child: _ActionTile(
                              icon: Icons.workspace_premium_outlined,
                              label: 'Membership',
                              onTap: () => onNavigate(3),
                            ),
                          ),
                        ],
                      ),
                      if (later.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _SectionHeader(
                          title: 'Newroz fixtures',
                          action: 'See all',
                          onAction: () => onNavigate(1),
                        ),
                        for (final match in later) _FixtureTile(match: match),
                      ],
                      const SizedBox(height: 24),
                      _SectionHeader(
                        title: 'Team shop',
                        action: 'Open shop',
                        onAction: () => onNavigate(2),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: ShopProducts.all.length < 6
                              ? ShopProducts.all.length
                              : 6,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final product = ShopProducts.all[index];
                            return GestureDetector(
                              onTap: () => onNavigate(2),
                              child: SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ProductArt(
                                        product: product,
                                        iconSize: 40,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      Formatters.currency(product.price),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _MembershipPromo(
                        tier: tier,
                        onTap: () => onNavigate(3),
                      ),
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
  const _Header({required this.name, required this.tier});

  final String name;
  final MembershipTier? tier;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top + 24,
        20,
        28,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.fire, AppColors.red],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department,
              color: Colors.white, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  name.isEmpty ? AppConstants.appName : name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _TierChip(tier: tier),
        ],
      ),
    );
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier});

  final MembershipTier? tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            tier?.label ?? 'Free fan',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextMatchCard extends StatelessWidget {
  const _NextMatchCard({required this.match, required this.onBook});

  final LeagueMatch match;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'NEXT NEWROZ MATCH',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.fire,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _Team(name: match.home)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'VS',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ),
                Expanded(child: _Team(name: match.away)),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.calendar_today_outlined, text: _when(match)),
            const SizedBox(height: 8),
            _InfoRow(
              icon: Icons.location_on_outlined,
              text: match.isNewrozHome ? AppConstants.venue : 'Away match',
            ),
            const SizedBox(height: 16),
            if (match.isNewrozHome)
              FilledButton.icon(
                onPressed: onBook,
                icon: const Icon(Icons.event_seat),
                label: const Text('Book tickets'),
              )
            else
              Text(
                'This is an away match. Tickets are sold by the home club.',
                style: theme.textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _NoMatchCard extends StatelessWidget {
  const _NoMatchCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: const Padding(
        padding: EdgeInsets.all(20),
        child: Text('No upcoming Newroz matches have been announced yet.'),
      ),
    );
  }
}

class _Team extends StatelessWidget {
  const _Team({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeamCrest(name: name, size: 56),
        const SizedBox(height: 8),
        Text(
          name,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
          TextButton(onPressed: onAction, child: Text(action)),
        ],
      ),
    );
  }
}

class _FixtureTile extends StatelessWidget {
  const _FixtureTile({required this.match});

  final LeagueMatch match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final opponent = match.isNewrozHome ? match.away : match.home;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        leading: TeamCrest(name: opponent, size: 40),
        title: Text('${match.home} vs ${match.away}'),
        subtitle: Text(_when(match)),
        trailing: Text(
          match.isNewrozHome ? 'HOME' : 'AWAY',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: match.isNewrozHome
                ? AppColors.green
                : theme.colorScheme.outline,
          ),
        ),
      ),
    );
  }
}

class _MembershipPromo extends StatelessWidget {
  const _MembershipPromo({required this.tier, required this.onTap});

  final MembershipTier? tier;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final current = tier;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.ink, Color(0xFF3B4147)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.workspace_premium, color: AppColors.gold, size: 32),
          const SizedBox(height: 8),
          Text(
            current == null
                ? 'Join the Newroz family'
                : '${current.label} member',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            current == null
                ? 'Save on merchandise and get early access to tickets.'
                : 'You save ${current.shopDiscountPercent}% in the team shop.',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.ink,
            ),
            child: Text(current == null ? 'View plans' : 'Manage membership'),
          ),
        ],
      ),
    );
  }
}
