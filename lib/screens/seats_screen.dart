import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/formatters.dart';
import '../core/theme.dart';
import '../models/seat.dart';
import '../providers/booking_provider.dart';
import '../widgets/booking_steps.dart';
import '../widgets/seat_widget.dart';
import '../widgets/selection_bar.dart';
import 'preview_screen.dart';

/// Step 2: pick seats inside one zone.
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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(34),
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: BookingSteps(current: 2),
          ),
        ),
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
            child: _SeatGrid(
              section: section,
              seats: seats,
              onSeatTap: (seat) => _onSeatTap(context, seat),
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

/// Rows are built lazily; the grid scrolls sideways on narrow screens.
class _SeatGrid extends StatelessWidget {
  const _SeatGrid({
    required this.section,
    required this.seats,
    required this.onSeatTap,
  });

  final StadiumSection section;

  /// Ordered by row, then seat number (see `BookingProvider.seatsFor`).
  final List<Seat> seats;
  final ValueChanged<Seat> onSeatTap;

  static const double _seatSize = 30;
  static const double _gap = 2;
  static const double _labelWidth = 32;
  static const double _sidePadding = 8;

  @override
  Widget build(BuildContext context) {
    const cell = _seatSize + _gap * 2;
    final perRow = section.seatsPerRow;
    final width = _labelWidth + perRow * cell + _sidePadding * 2;

    final list = SizedBox(
      width: width,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(_sidePadding, 8, _sidePadding, 24),
        itemCount: section.rows + 2,
        itemBuilder: (context, index) {
          if (index == 0) return const _PitchDirection();
          if (index == 1) return _NumberHeader(perRow: perRow);

          final row = index - 1;
          final rowSeats = seats.sublist((row - 1) * perRow, row * perRow);
          return _SeatRow(
            row: row,
            seats: rowSeats,
            color: section.color,
            onSeatTap: onSeatTap,
          );
        },
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= width) return Center(child: list);
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: list,
        );
      },
    );
  }
}

class _NumberHeader extends StatelessWidget {
  const _NumberHeader({required this.perRow});

  final int perRow;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 9);
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Row(
        children: [
          const SizedBox(width: _SeatGrid._labelWidth),
          for (var n = 1; n <= perRow; n++)
            SizedBox(
              width: _SeatGrid._seatSize + _SeatGrid._gap * 2,
              child: Center(child: Text('$n', style: style)),
            ),
        ],
      ),
    );
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
    return Row(
      children: [
        SizedBox(
          width: _SeatGrid._labelWidth,
          child: Text(
            'R$row',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
        for (final seat in seats)
          Padding(
            padding: const EdgeInsets.all(_SeatGrid._gap),
            child: SizedBox(
              width: _SeatGrid._seatSize,
              height: _SeatGrid._seatSize,
              child: SeatWidget(
                seat: seat,
                sectionColor: color,
                onTap: () => onSeatTap(seat),
              ),
            ),
          ),
      ],
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
      decoration: const BoxDecoration(
        color: AppColors.pitch,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
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
