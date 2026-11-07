import 'package:flutter/foundation.dart';

/// The person who is logged in.
@immutable
class AppUser {
  const AppUser({required this.id, required this.name, required this.phone});

  final int id;
  final String name;
  final String phone;

  /// Removes spaces and dashes so `+964 750-123` equals `+964750123`.
  static String normalizePhone(String raw) =>
      raw.replaceAll(RegExp(r'[\s-]'), '');

  factory AppUser.fromMap(Map<String, Object?> map) => AppUser(
        id: map['id']! as int,
        name: map['name']! as String,
        phone: map['phone']! as String,
      );
}
