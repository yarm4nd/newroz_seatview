import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/formatters.dart';
import '../core/translator.dart';
import '../models/membership_tier.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/membership_provider.dart';

class MembershipScreen extends StatelessWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = context.watch<AuthProvider>().user?.id;
    final current = context.watch<MembershipProvider>().tierFor(userId);
    final lang = context.watch<LocaleProvider>().language;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'membership'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(AppStrings.of(lang, 'join_family'), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(AppStrings.of(lang, 'member_sub'), style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              for (final tier in MembershipTier.values) ...[
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: tier == current ? tier.color : theme.colorScheme.outlineVariant, width: tier == current ? 2 : 1),
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
                              child: Text(Tr.text(lang, tier.label), style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                            ),
                            if (tier.popular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                                child: Text(AppStrings.of(lang, 'most_popular'), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(Tr.text(lang, tier.tagline), style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 8),
                            Text('${Tr.text(lang, Formatters.currency(tier.monthlyPrice))} ${AppStrings.of(lang, 'per_month')}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 12),
                            for (final perk in tier.perks)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle, size: 18, color: tier.color),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(Tr.text(lang, perk))),
                                  ],
                                ),
                              ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: tier == current || userId == null
                                  ? null
                                  : () => context.read<MembershipProvider>().subscribe(userId, tier),
                              style: FilledButton.styleFrom(backgroundColor: tier.color),
                              child: Text(tier == current ? AppStrings.of(lang, 'current_plan') : Tr.text(lang, tier.label)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
