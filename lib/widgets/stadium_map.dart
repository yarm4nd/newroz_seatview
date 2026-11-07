import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/seat.dart';

/// Top-down stadium plan: pitch in the middle, 12 tappable blocks around it.
class StadiumMap extends StatelessWidget {
  const StadiumMap({
    super.key,
    required this.availableIn,
    required this.selectedIn,
    required this.onSectionTap,
  });

  final int Function(StadiumSection section) availableIn;
  final int Function(StadiumSection section) selectedIn;
  final ValueChanged<StadiumSection> onSectionTap;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: _strip(StadiumSection.north, Axis.horizontal),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 6,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _strip(StadiumSection.west, Axis.vertical),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(flex: 5, child: _Pitch()),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _strip(StadiumSection.east, Axis.vertical),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: _strip(StadiumSection.south, Axis.horizontal),
            ),
          ],
        ),
      ),
    );
  }

  /// A row (or column) of blocks of one stand.
  Widget _strip(List<StadiumSection> sections, Axis axis) {
    final children = <Widget>[];
    for (var i = 0; i < sections.length; i++) {
      if (i > 0) {
        children.add(
          axis == Axis.horizontal
              ? const SizedBox(width: 6)
              : const SizedBox(height: 6),
        );
      }
      children.add(Expanded(child: _tile(sections[i])));
    }
    return Flex(direction: axis, children: children);
  }

  Widget _tile(StadiumSection section) {
    return _SectionTile(
      section: section,
      available: availableIn(section),
      selected: selectedIn(section),
      onTap: () => onSectionTap(section),
    );
  }
}

class _SectionTile extends StatelessWidget {
  const _SectionTile({
    required this.section,
    required this.available,
    required this.selected,
    required this.onTap,
  });

  final StadiumSection section;
  final int available;
  final int selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final soldOut = available == 0;
    final color = soldOut ? AppColors.booked : section.color;

    return Semantics(
      button: true,
      label: '${section.name}, $available seats available',
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: soldOut ? null : onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      section.id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      soldOut ? 'Sold out' : '$available left',
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    if (selected > 0)
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$selected selected',
                          style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Pitch extends StatelessWidget {
  const _Pitch();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CustomPaint(
        painter: _PitchPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.pitch);

    final line = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final field = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    canvas.drawRect(field, line);
    canvas.drawLine(
      Offset(field.left, field.center.dy),
      Offset(field.right, field.center.dy),
      line,
    );
    canvas.drawCircle(field.center, size.shortestSide * 0.14, line);

    final boxWidth = field.width * 0.5;
    final boxHeight = field.height * 0.14;
    canvas.drawRect(
      Rect.fromLTWH(
        field.center.dx - boxWidth / 2,
        field.top,
        boxWidth,
        boxHeight,
      ),
      line,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        field.center.dx - boxWidth / 2,
        field.bottom - boxHeight,
        boxWidth,
        boxHeight,
      ),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
