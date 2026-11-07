import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../core/theme.dart';
import '../models/seat.dart';
import '../providers/booking_provider.dart';
import '../widgets/seat_widget.dart';
import '../widgets/selection_bar.dart';
import 'preview_screen.dart';

/// Step 2: pick seats inside one stand.
class SeatsScreen extends StatelessWidget {
  const SeatsScreen({super.key, required this.section});

  final StadiumSection section;

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final seats = booking.seatsFor(section);

    return Scaffold(
      appBar: AppBar(
        title: Text(section.name),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(Formatters.currency(section.price))),
          ),
        ],
      ),
      body: Column(
        children: [
          const _Legend(),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  children: [
                    const _PitchDirection(),
                    const SizedBox(height: 16),
                    for (var row = 1; row <= section.rows; row++)
                      _SeatRow(
                        row: row,
                        seats: seats
                            .where((seat) => seat.row == row)
                            .toList(growable: false),
                        color: section.color,
                        onSeatTap: (seat) => _onSeatTap(context, seat),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
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

  void _onSeatTap(BuildContext context, Seat seat) {
    final ok = context.read<BookingProvider>().toggleSeat(seat);
    if (!ok && !seat.isBooked) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(
              'You can book up to ${AppConstants.maxSeatsPerBooking} seats at once.',
            ),
          ),
        );
    }
  }
}

class _SeatRow extends StatelessWidget {
  const _SeatRow({
    required this.row,
    required this.seats,
    required this.color,
    required this.onSeatTap,
  });

  final int row;
  final List<Seat> seats;
  final Color color;
  final ValueChanged<Seat> onSeatTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$row',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
          for (final seat in seats)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SeatWidget(
                  seat: seat,
                  sectionColor: color,
                  onTap: () => onSeatTap(seat),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PitchDirection extends StatelessWidget {
  const _PitchDirection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.pitch,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: const Text(
        'PITCH',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          letterSpacing: 3,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(color: Color(0x4D1C7ED6), label: 'Available'),
          SizedBox(width: 20),
          _LegendItem(color: AppColors.green, label: 'Selected'),
          SizedBox(width: 20),
          _LegendItem(color: AppColors.booked, label: 'Booked'),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
