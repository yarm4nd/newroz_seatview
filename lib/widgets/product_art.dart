import 'package:flutter/material.dart';

import '../models/product.dart';

/// Colour tile with an icon. Swap for `Image.asset` when you have photos.
class ProductArt extends StatelessWidget {
  const ProductArt({
    super.key,
    required this.product,
    this.iconSize = 56,
    this.radius = 16,
  });

  final Product product;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            product.color,
            Color.lerp(product.color, Colors.black, 0.35)!
          ],
        ),
      ),
      child: Center(
        child: Icon(product.icon, size: iconSize, color: Colors.white),
      ),
    );
  }
}
