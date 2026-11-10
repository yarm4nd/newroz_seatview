import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../models/product.dart';

/// Team shop catalogue. Prices are placeholders: change them to your own.
class ShopProducts {
  const ShopProducts._();

  static const List<Product> all = [
    Product(
      id: 'home-jersey',
      name: 'Home Jersey 2026–27',
      category: ProductCategory.kits,
      price: 45000,
      description: 'Official orange home jersey with the club crest.',
      color: AppColors.fire,
      icon: Icons.checkroom,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    ),
    Product(
      id: 'away-jersey',
      name: 'Away Jersey 2026–27',
      category: ProductCategory.kits,
      price: 45000,
      description: 'Official dark away jersey for match days on the road.',
      color: AppColors.ink,
      icon: Icons.checkroom,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    ),
    Product(
      id: 'kids-jersey',
      name: 'Kids Jersey',
      category: ProductCategory.kits,
      price: 30000,
      description: 'The home jersey in kids sizes.',
      color: AppColors.red,
      icon: Icons.checkroom,
      sizes: ['6Y', '8Y', '10Y', '12Y', '14Y'],
    ),
    Product(
      id: 'training-top',
      name: 'Training Top',
      category: ProductCategory.apparel,
      price: 30000,
      description: 'Light breathable top, the same one the players train in.',
      color: AppColors.green,
      icon: Icons.sports_gymnastics,
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    Product(
      id: 'hoodie',
      name: 'Club Hoodie',
      category: ProductCategory.apparel,
      price: 55000,
      description: 'Warm fleece hoodie for the winter match days.',
      color: Color(0xFF495057),
      icon: Icons.dry_cleaning,
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    ),
    Product(
      id: 'cap',
      name: 'Newroz Cap',
      category: ProductCategory.apparel,
      price: 12000,
      description: 'Adjustable cap with the embroidered crest.',
      color: AppColors.red,
      icon: Icons.sports_baseball,
    ),
    Product(
      id: 'scarf',
      name: 'Fan Scarf',
      category: ProductCategory.fanGear,
      price: 10000,
      description: 'Classic stadium scarf in the club colours.',
      color: AppColors.gold,
      icon: Icons.waves,
    ),
    Product(
      id: 'flag',
      name: 'Club Flag',
      category: ProductCategory.fanGear,
      price: 8000,
      description: 'Large flag to wave in the stands.',
      color: AppColors.fire,
      icon: Icons.flag,
    ),
    Product(
      id: 'ball',
      name: 'Newroz Football',
      category: ProductCategory.fanGear,
      price: 25000,
      description: 'Size 5 football with the club branding.',
      color: AppColors.pitch,
      icon: Icons.sports_soccer,
    ),
    Product(
      id: 'keychain',
      name: 'Keychain',
      category: ProductCategory.fanGear,
      price: 3000,
      description: 'Metal keychain with the crest.',
      color: Color(0xFF0B7285),
      icon: Icons.key,
    ),
  ];
}
