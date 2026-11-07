import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/seat.dart';

/// One tappable seat. Color depends on its [SeatStatus].
class SeatWidget extends StatelessWidget {
  const SeatWidget({
    super.key,
    required this.seat,
    required this.sectionColor,
    required this.onTap,
  });

  final Seat seat;
  final Color sectionColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color;
    switch (seat.status) {
      case SeatStatus.available:
        color = sectionColor.withValues(alpha: 0.28);
      case SeatStatus.booked:
        color = AppColors.booked;
      case SeatStatus.selected:
        color = AppColors.green;
    }

    return Semantics(
      button: true,
      enabled: !seat.isBooked,
      selected: seat.isSelected,
      label: '${seat.label}, ${seat.status.name}',
      child: GestureDetector(
        onTap: seat.isBooked ? null : onTap,
        child: AspectRatio(
          aspectRatio: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(8),
                bottom: Radius.circular(3),
              ),
              border: Border.all(
                color: seat.isBooked ? color : sectionColor,
                width: seat.isSelected ? 2 : 1,
              ),
            ),
            child: seat.isSelected
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : null,
          ),
        ),
      ),
    );
  }
}
