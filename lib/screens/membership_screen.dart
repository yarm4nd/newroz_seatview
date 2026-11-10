import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/membership_tier.dart';
import '../providers/auth_provider.dart';
import '../providers/membership_provider.dart';

/// Membership plans: Silver, Gold and Platinum.
class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  Future<void> _choose(BuildContext context, MembershipTier tier) async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    final membership = context.read<MembershipProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Join ${tier.label}?'),
        content: Text(
          '${Formatters.currency(tier.monthlyPrice)} per month.\n\n'
          'Demo mode: no payment is taken and the plan is saved on this device only.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Join'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await membership.subscribe(userId, tier);
    messenger.showSnackBar(
      SnackBar(content: Text('Welcome to ${tier.label}!')),
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final userId = context.read<AuthProvider>().user?.id;
    if (userId == null) return;
    final membership = context.read<MembershipProvider>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancel membership?'),
        content: const Text('You will lose your member discounts.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cancel membership'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await membership.cancel(userId);
    messenger.showSnackBar(
      const SnackBar(content: Text('Membership cancelled.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = context.watch<AuthProvider>().user?.id;
    final current = context.watch<MembershipProvider>().tierFor(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('Membership')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Join the Newroz family',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                current == null
                    ? 'You are a free fan. Pick a plan to unlock discounts.'
                    : 'Your plan: ${current.label} '
                        '(${current.shopDiscountPercent}% off in the shop)',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              for (final tier in MembershipTier.values) ...[
                _PlanCard(
                  tier: tier,
                  isCurrent: tier == current,
                  hasPlan: current != null,
                  onChoose: () => _choose(context, tier),
                ),
                const SizedBox(height: 12),
              ],
              if (current != null)
                TextButton(
                  onPressed: () => _cancel(context),
                  child: const Text('Cancel membership'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.tier,
    required this.isCurrent,
    required this.hasPlan,
    required this.onChoose,
  });

  final MembershipTier tier;
  final bool isCurrent;
  final bool hasPlan;
  final VoidCallback onChoose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isCurrent ? tier.color : theme.colorScheme.outlineVariant,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: tier.color,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tier.label,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (tier.popular)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'MOST POPULAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tier.tagline, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(
                  '${Formatters.currency(tier.monthlyPrice)} / month',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                for (final perk in tier.perks)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, size: 18, color: tier.color),
                        const SizedBox(width: 8),
                        Expanded(child: Text(perk)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                if (isCurrent)
                  const OutlinedButton(
                    onPressed: null,
                    child: Text('Current plan'),
                  )
                else
                  FilledButton(
                    onPressed: onChoose,
                    style: FilledButton.styleFrom(backgroundColor: tier.color),
                    child: Text(
                      hasPlan
                          ? 'Switch to ${tier.label}'
                          : 'Choose ${tier.label}',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
