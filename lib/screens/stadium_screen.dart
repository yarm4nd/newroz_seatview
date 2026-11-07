import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../models/seat.dart';
import '../providers/booking_provider.dart';
import '../widgets/selection_bar.dart';
import '../widgets/stadium_map.dart';
import 'preview_screen.dart';
import 'seats_screen.dart';

/// Step 1: choose a stand on the stadium plan.
class StadiumScreen extends StatelessWidget {
  const StadiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a stand')),
      body: booking.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    StadiumMap(
                      availableIn: booking.availableCount,
                      selectedIn: booking.selectedCountIn,
                      onSectionTap: (section) => _openSection(context, section),
                    ),
                    const SizedBox(height: 20),
                    for (final section in StadiumSection.all)
                      _SectionRow(
                        section: section,
                        available: booking.availableCount(section),
                        onTap: () => _openSection(context, section),
                      ),
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
      margin: const EdgeInsets.only(bottom: 10),
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
        title: Text(section.name),
        subtitle: Text(
          soldOut ? 'Sold out' : '$available of ${section.capacity} available',
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
