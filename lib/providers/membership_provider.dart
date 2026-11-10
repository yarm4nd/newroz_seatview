import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/membership_tier.dart';

/// Stores each account's membership plan on this device.
class MembershipProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (error) {
      debugPrint('MembershipProvider init error: $error');
    }
    notifyListeners();
  }

  String _key(int userId) => 'membership_$userId';

  /// The plan of [userId], or null for a free fan.
  MembershipTier? tierFor(int? userId) {
    if (userId == null) return null;
    final saved = _prefs?.getString(_key(userId));
    if (saved == null) return null;
    for (final tier in MembershipTier.values) {
      if (tier.name == saved) return tier;
    }
    return null;
  }

  Future<void> subscribe(int userId, MembershipTier tier) async {
    await _prefs?.setString(_key(userId), tier.name);
    notifyListeners();
  }

  Future<void> cancel(int userId) async {
    await _prefs?.remove(_key(userId));
    notifyListeners();
  }
}
