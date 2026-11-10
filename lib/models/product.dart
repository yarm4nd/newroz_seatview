import 'package:flutter/material.dart';

enum ProductCategory {
  kits('Kits'),
  apparel('Apparel'),
  fanGear('Fan gear');

  const ProductCategory(this.label);

  final String label;
}

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.color,
    required this.icon,
    this.sizes = const [],
  });

  final String id;
  final String name;
  final ProductCategory category;

  /// Price in IQD.
  final int price;
  final String description;
  final Color color;
  final IconData icon;

  /// Empty when the product has no sizes (scarf, ball...).
  final List<String> sizes;

  /// Price after a membership discount of [percent] %.
  int priceWith(int percent) => price - price * percent ~/ 100;
}
