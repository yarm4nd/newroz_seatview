import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../providers/booking_provider.dart';
import 'booking_screen.dart';

/// Step 3: review the selected seats before entering personal details.
class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final seats = booking.selectedSeats;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Review your seats')),
      body: seats.isEmpty
          ? const Center(child: Text('No seats selected'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: seats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final seat = seats[index];
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: seat.section.color,
                          child: Text(
                            seat.sectionId,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        title: Text(seat.section.name),
                        subtitle: Text(seat.label),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Formatters.currency(seat.section.price)),
                            IconButton(
                              tooltip: 'Remove seat',
                              icon: const Icon(Icons.close),
                              onPressed: () => context
                                  .read<BookingProvider>()
                                  .removeSelected(seat.key),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
      bottomNavigationBar: seats.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total', style: theme.textTheme.titleMedium),
                        Text(
                          Formatters.currency(booking.totalPrice),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const BookingScreen(),
                        ),
                      ),
                      child: const Text('Enter your details'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
