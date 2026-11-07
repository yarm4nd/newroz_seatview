import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/seat.dart';
import '../providers/booking_provider.dart';
import '../widgets/selection_bar.dart';
import '../widgets/stadium_map.dart';
import 'preview_screen.dart';
import 'seats_screen.dart';

/// Step 1: choose a block on the stadium plan.
class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final theme = Theme.of(context);
    final capacity =
        NumberFormat.decimalPattern().format(StadiumSection.totalCapacity);

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a block')),
      body: booking.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Stadium capacity: $capacity seats',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    StadiumMap(
                      availableIn: booking.availableCount,
                      selectedIn: booking.selectedCountIn,
                      onSectionTap: (section) => _openSection(context, section),
                    ),
                    const SizedBox(height: 12),
                    for (final stand in StadiumSection.stands) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 12, 4, 8),
                        child: Text(
                          stand,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      for (final section in StadiumSection.inStand(stand))
                        _SectionRow(
                          section: section,
                          available: booking.availableCount(section),
                          onTap: () => _openSection(context, section),
                        ),
                    ],
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SelectionBar(
        count: booking.selectedCount,
        total: booking.totalPrice,
        onContinue: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const PreviewScreen()),
        ),
      ),
    );
  }

  void _openSection(BuildContext context, StadiumSection section) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SeatsScreen(section: section)),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({
    required this.section,
    required this.available,
    required this.onTap,
  });

  final StadiumSection section;
  final int available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final soldOut = available == 0;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: ListTile(
        onTap: soldOut ? null : onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: CircleAvatar(
          backgroundColor: section.color,
          child: Text(
            section.id,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        title: Text('Block ${section.block}'),
        subtitle: Text(
          soldOut
              ? 'Sold out'
              : '$available of ${section.capacity} seats available',
        ),
        trailing: Text(
          Formatters.currency(section.price),
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
