import 'package:flutter/material.dart';

import '../core/formatters.dart';

/// Bottom bar showing how many seats are selected and the total price.
class SelectionBar extends StatelessWidget {
  const SelectionBar({
    super.key,
    required this.count,
    required this.total,
    required this.onContinue,
  });

  final int count;
  final int total;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 12, offset: Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    count == 1 ? '1 seat' : '$count seats',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    Formatters.currency(total),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 160,
              child: FilledButton(
                onPressed: onContinue,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
