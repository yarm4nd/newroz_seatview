import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/seat.dart';
import '../models/ticket_package.dart';

enum _Corner { topLeft, topRight, bottomLeft, bottomRight }

/// Top-down zone map: pitch in the middle, zones around it.
///
/// Zones are pink. When a package is selected, its zones take the package
/// colour. The selected zone gets a dark outline.
class StadiumMap extends StatelessWidget {
  const StadiumMap({
    super.key,
    required this.selectedPackage,
    required this.selectedZoneId,
    required this.availableIn,
    required this.onZoneTap,
  });

  final TicketPackage? selectedPackage;
  final String? selectedZoneId;
  final int Function(StadiumSection zone) availableIn;
  final ValueChanged<StadiumSection> onZoneTap;

  static const double _gap = 6;
  static const Color _frame = Color(0xFFD3D3D8);
  static const Color _pink = Color(0xFFF6C9CE);
  static const Color _pinkDim = Color(0xFFF1E2E4);
  static const Color _soldOut = Color(0xFFB9BBC2);
  static const Color _darkText = Color(0xFF5B4B4E);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 663 / 502,
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(flex: 22, child: _corner('L', _Corner.topLeft)),
                const SizedBox(width: _gap),
                Expanded(flex: 100, child: _frameBox(_topStrip())),
                const SizedBox(width: _gap),
                Expanded(flex: 22, child: _corner('R', _Corner.topRight)),
              ],
            ),
          ),
          const SizedBox(height: _gap),
          Expanded(
            flex: 29,
            child: Row(
              children: [
                Expanded(flex: 22, child: _frameBox(_leftStrip())),
                const SizedBox(width: _gap),
                const Expanded(flex: 100, child: _Pitch()),
                const SizedBox(width: _gap),
                Expanded(flex: 22, child: _frameBox(_rightStrip())),
              ],
            ),
          ),
          const SizedBox(height: _gap),
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Expanded(flex: 22, child: _corner('G', _Corner.bottomLeft)),
                const SizedBox(width: _gap),
                Expanded(flex: 100, child: _frameBox(_bottomStrip())),
                const SizedBox(width: _gap),
                Expanded(flex: 22, child: _corner('W', _Corner.bottomRight)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------ strips

  Widget _topStrip() => _row([
        _h('M', 38),
        _hSmall('M1', '7', 21, gateOnTop: false),
        _h('N', 76),
        _hSmall('N1', '8', 30, gateOnTop: false),
        _h('O', 69),
        _hSmall('O1', '9', 30, gateOnTop: false),
        _h('P', 68),
        _hSmall('P1', '10', 30, gateOnTop: false),
        _h('Q', 38),
      ]);

  Widget _bottomStrip() => _row([
        _h('F', 38),
        _hSmall('E1', '4', 31, gateOnTop: true),
        _h('E', 67),
        _hSmall('D1', '3', 30, gateOnTop: true),
        _h('D', 29),
        _h('C', 30),
        _hSmall('B1', '2', 30, gateOnTop: true),
        _h('B', 68),
        _hSmall('A1', '1', 30, gateOnTop: true),
        _h('A', 38),
      ]);

  Widget _leftStrip() => _column([
        _v('K', 30),
        _vSmall('J1', '6', 30, gateOnRight: true),
        _v('J', 69),
        _v('I', 69),
        _vSmall('H1', '5', 30, gateOnRight: true),
        _v('H', 30),
      ]);

  Widget _rightStrip() => _column([
        _v('S', 30),
        _vSmall('S1', '11', 30, gateOnRight: false),
        _v('T', 69),
        _v('U', 69),
        _vSmall('U1', '12', 30, gateOnRight: false),
        _v('V', 30),
      ]);

  // ----------------------------------------------------------------- helpers

  Widget _frameBox(Widget child) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _frame,
          borderRadius: BorderRadius.circular(4),
        ),
        child: child,
      );

  Widget _row(List<Widget> items) =>
      Row(children: _spaced(items, Axis.horizontal));

  Widget _column(List<Widget> items) =>
      Column(children: _spaced(items, Axis.vertical));

  List<Widget> _spaced(List<Widget> items, Axis axis) {
    final result = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) {
        result.add(
          axis == Axis.horizontal
              ? const SizedBox(width: 3)
              : const SizedBox(height: 3),
        );
      }
      result.add(items[i]);
    }
    return result;
  }

  Widget _h(String id, int flex) => Expanded(flex: flex, child: _tile(id));

  Widget _v(String id, int flex) => Expanded(flex: flex, child: _tile(id));

  /// A small zone with a gate number above or below it.
  Widget _hSmall(String id, String gate, int flex, {required bool gateOnTop}) {
    final zone = Expanded(flex: 3, child: _tile(id));
    final gateBox = Expanded(flex: 2, child: _Gate(gate));
    return Expanded(
      flex: flex,
      child: Column(
        children: gateOnTop
            ? [gateBox, const SizedBox(height: 2), zone]
            : [zone, const SizedBox(height: 2), gateBox],
      ),
    );
  }

  /// A small zone with a gate number on its left or right.
  Widget _vSmall(String id, String gate, int flex,
      {required bool gateOnRight}) {
    final zone = Expanded(flex: 3, child: _tile(id));
    final gateBox = Expanded(flex: 2, child: _Gate(gate));
    return Expanded(
      flex: flex,
      child: Row(
        children: gateOnRight
            ? [zone, const SizedBox(width: 2), gateBox]
            : [gateBox, const SizedBox(width: 2), zone],
      ),
    );
  }

  Color _fill(StadiumSection zone) {
    if (availableIn(zone) == 0) return _soldOut;
    final package = selectedPackage;
    if (package == null) return _pink;
    return zone.package == package ? package.color : _pinkDim;
  }

  Color _textColor(StadiumSection zone) {
    final package = selectedPackage;
    final filled =
        package != null && zone.package == package && availableIn(zone) > 0;
    return filled ? Colors.white : _darkText;
  }

  Widget _tile(String id) {
    final zone = StadiumSection.byId(id);
    final available = availableIn(zone);
    return _ZoneTile(
      zone: zone,
      fill: _fill(zone),
      textColor: _textColor(zone),
      selected: zone.id == selectedZoneId,
      available: available,
      onTap: () => onZoneTap(zone),
    );
  }

  Widget _corner(String id, _Corner corner) {
    final zone = StadiumSection.byId(id);
    final available = availableIn(zone);
    return _CornerTile(
      zone: zone,
      corner: corner,
      fill: _fill(zone),
      textColor: _textColor(zone),
      selected: zone.id == selectedZoneId,
      available: available,
      onTap: () => onZoneTap(zone),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF6B6B72)),
        ),
      ),
    );
  }
}

class _ZoneTile extends StatelessWidget {
  const _ZoneTile({
    required this.zone,
    required this.fill,
    required this.textColor,
    required this.selected,
    required this.available,
    required this.onTap,
  });

  final StadiumSection zone;
  final Color fill;
  final Color textColor;
  final bool selected;
  final int available;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${zone.name}, ${zone.package.label}, $available seats left',
      child: Material(
        color: fill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: selected
              ? const BorderSide(color: AppColors.ink, width: 2.5)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: available == 0 ? null : onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  zone.id,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CornerTile extends StatelessWidget {
  const _CornerTile({
    required this.zone,
    required this.corner,
    required this.fill,
    required this.textColor,
    required this.selected,
    required this.available,
    required this.onTap,
  });

  final StadiumSection zone;
  final _Corner corner;
  final Color fill;
  final Color textColor;
  final bool selected;
  final int available;
  final VoidCallback onTap;

  Alignment get _labelAlignment => switch (corner) {
        _Corner.topLeft => const Alignment(-0.4, -0.4),
        _Corner.topRight => const Alignment(0.4, -0.4),
        _Corner.bottomLeft => const Alignment(-0.4, 0.4),
        _Corner.bottomRight => const Alignment(0.4, 0.4),
      };

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${zone.name}, ${zone.package.label}, $available seats left',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: available == 0 ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: StadiumMap._frame,
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomPaint(
            painter: _TrianglePainter(
              fill: fill,
              corner: corner,
              outline: selected,
            ),
            child: Align(
              alignment: _labelAlignment,
              child: Text(
                zone.id,
                style: TextStyle(
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  const _TrianglePainter({
    required this.fill,
    required this.corner,
    required this.outline,
  });

  final Color fill;
  final _Corner corner;
  final bool outline;

  @override
  void paint(Canvas canvas, Size size) {
    const margin = 0.1;
    final l = size.width * margin;
    final r = size.width * (1 - margin);
    final t = size.height * margin;
    final b = size.height * (1 - margin);

    final path = Path();
    switch (corner) {
      case _Corner.topLeft:
        path
          ..moveTo(l, t)
          ..lineTo(r, t)
          ..lineTo(l, b)
          ..close();
      case _Corner.topRight:
        path
          ..moveTo(r, t)
          ..lineTo(l, t)
          ..lineTo(r, b)
          ..close();
      case _Corner.bottomLeft:
        path
          ..moveTo(l, b)
          ..lineTo(l, t)
          ..lineTo(r, b)
          ..close();
      case _Corner.bottomRight:
        path
          ..moveTo(r, b)
          ..lineTo(r, t)
          ..lineTo(l, b)
          ..close();
    }

    canvas.drawPath(path, Paint()..color = fill);
    if (outline) {
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeJoin = StrokeJoin.round
          ..color = AppColors.ink,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) =>
      oldDelegate.fill != fill ||
      oldDelegate.corner != corner ||
      oldDelegate.outline != outline;
}

class _Pitch extends StatelessWidget {
  const _Pitch();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
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
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF4CB85C));

    final line = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final w = size.width;
    final h = size.height;

    canvas.drawLine(Offset(w / 2, 0), Offset(w / 2, h), line);
    canvas.drawCircle(Offset(w / 2, h / 2), h * 0.16, line);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.225, w * 0.16, h * 0.55), line);
    canvas.drawRect(
        Rect.fromLTWH(w * 0.84, h * 0.225, w * 0.16, h * 0.55), line);
    canvas.drawRect(Rect.fromLTWH(0, h * 0.36, w * 0.06, h * 0.28), line);
    canvas.drawRect(
        Rect.fromLTWH(w * 0.94, h * 0.36, w * 0.06, h * 0.28), line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
