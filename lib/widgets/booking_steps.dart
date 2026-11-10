import 'package:flutter/material.dart';

/// Four progress dots: Package, Seats, Review, Details.
class BookingSteps extends StatelessWidget {
  const BookingSteps({super.key, required this.current});

  /// 1 to 4.
  final int current;

  static const int _total = 4;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final active = scheme.primary;
    final idle = scheme.outlineVariant;

    final children = <Widget>[];
    for (var step = 1; step <= _total; step++) {
      if (step > 1) {
        children.add(
          Expanded(
            child: Container(
              height: 3,
              color: step <= current ? active : idle,
            ),
          ),
        );
      }
      children.add(
        _Dot(
          isCurrent: step == current,
          isDone: step < current,
          active: active,
          idle: idle,
        ),
      );
    }

    return Semantics(
      label: 'Step $current of $_total',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(children: children),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({
    required this.isCurrent,
    required this.isDone,
    required this.active,
    required this.idle,
  });

  final bool isCurrent;
  final bool isDone;
  final Color active;
  final Color idle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? active : Colors.white,
        border: Border.all(
          color: isCurrent || isDone ? active : idle,
          width: isCurrent ? 6 : 2,
        ),
      ),
      child: isDone
          ? const Icon(Icons.check, size: 13, color: Colors.white)
          : null,
    );
  }
}
