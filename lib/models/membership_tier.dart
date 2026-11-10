import 'package:flutter/material.dart';

/// Paid membership plans. Not being a member is the free "fan" level.
enum MembershipTier {
  silver(
    label: 'Silver',
    tagline: 'For regular supporters',
    monthlyPrice: 10000,
    shopDiscountPercent: 5,
    color: Color(0xFF6C757D),
    perks: [
      '5% off in the team shop',
      'Member badge in the app',
      'Ticket sale reminders',
    ],
  ),
  gold(
    label: 'Gold',
    tagline: 'The most popular plan',
    monthlyPrice: 25000,
    shopDiscountPercent: 10,
    color: Color(0xFFC77700),
    popular: true,
    perks: [
      '10% off in the team shop',
      '24-hour early access to ticket sales',
      '5% off match tickets',
      'Exclusive member offers',
    ],
  ),
  platinum(
    label: 'Platinum',
    tagline: 'For the biggest fans',
    monthlyPrice: 50000,
    shopDiscountPercent: 15,
    color: Color(0xFF343A40),
    perks: [
      '15% off in the team shop',
      '48-hour early access to ticket sales',
      '10% off match tickets',
      'Free scarf every season',
      'Invitations to club events',
    ],
  );

  const MembershipTier({
    required this.label,
    required this.tagline,
    required this.monthlyPrice,
    required this.shopDiscountPercent,
    required this.color,
    required this.perks,
    this.popular = false,
  });

  final String label;
  final String tagline;

  /// Price in IQD per month.
  final int monthlyPrice;
  final int shopDiscountPercent;
  final Color color;
  final List<String> perks;
  final bool popular;
}
