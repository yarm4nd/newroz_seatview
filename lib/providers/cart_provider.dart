import 'package:flutter/foundation.dart';

import '../models/product.dart';

class CartLine {
  CartLine({required this.product, this.size, this.quantity = 1});

  final Product product;
  final String? size;
  int quantity;

  static String keyFor(Product product, String? size) =>
      '${product.id}|${size ?? ''}';

  String get key => keyFor(product, size);
  int get total => product.price * quantity;
}

/// Shopping cart. It lives in memory only (it is cleared when the app closes).
class CartProvider extends ChangeNotifier {
  static const int maxPerLine = 10;

  final Map<String, CartLine> _lines = {};

  List<CartLine> get lines => _lines.values.toList(growable: false);
  bool get isEmpty => _lines.isEmpty;

  int get count => _lines.values.fold(0, (sum, line) => sum + line.quantity);
  int get subtotal => _lines.values.fold(0, (sum, line) => sum + line.total);

  int discountFor(int percent) => subtotal * percent ~/ 100;

  void add(Product product, {String? size}) {
    final key = CartLine.keyFor(product, size);
    final existing = _lines[key];
    if (existing == null) {
      _lines[key] = CartLine(product: product, size: size);
    } else if (existing.quantity < maxPerLine) {
      existing.quantity++;
    }
    notifyListeners();
  }

  void increase(String key) {
    final line = _lines[key];
    if (line == null || line.quantity >= maxPerLine) return;
    line.quantity++;
    notifyListeners();
  }

  void decrease(String key) {
    final line = _lines[key];
    if (line == null) return;
    if (line.quantity <= 1) {
      _lines.remove(key);
    } else {
      line.quantity--;
    }
    notifyListeners();
  }

  void clear() {
    if (_lines.isEmpty) return;
    _lines.clear();
    notifyListeners();
  }
}
