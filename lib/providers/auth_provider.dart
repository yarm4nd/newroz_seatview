import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/exceptions.dart';
import '../core/password_hasher.dart';
import '../models/app_user.dart';
import '../services/database_service.dart';

/// Keeps track of who is logged in. The session survives app restarts.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._db);

  static const String _sessionKey = 'session_user_id';

  final DatabaseService _db;

  AppUser? _user;
  bool _isInitializing = true;

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isInitializing => _isInitializing;

  /// Restores the saved session, if any.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getInt(_sessionKey);
      if (id != null) {
        final row = await _db.findUserById(id);
        if (row != null) {
          _user = AppUser.fromMap(row);
        } else {
          await prefs.remove(_sessionKey);
        }
      }
    } catch (error) {
      debugPrint('AuthProvider init error: $error');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Creates an account and logs in.
  ///
  /// Throws [PhoneAlreadyRegisteredException] if the phone is taken.
  Future<void> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    final normalized = AppUser.normalizePhone(phone);
    final salt = PasswordHasher.generateSalt();
    final id = await _db.insertUser(
      name: name.trim(),
      phone: normalized,
      passwordHash: PasswordHasher.hash(password, salt),
      salt: salt,
      createdAt: DateTime.now(),
    );
    await _startSession(
      AppUser(id: id, name: name.trim(), phone: normalized),
    );
  }

  /// Throws [InvalidCredentialsException] if phone or password is wrong.
  Future<void> login({required String phone, required String password}) async {
    final row = await _db.findUserByPhone(AppUser.normalizePhone(phone));
    if (row == null) throw const InvalidCredentialsException();

    final valid = PasswordHasher.verify(
      password,
      row['salt']! as String,
      row['password_hash']! as String,
    );
    if (!valid) throw const InvalidCredentialsException();

    await _startSession(AppUser.fromMap(row));
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    _user = null;
    notifyListeners();
  }

  Future<void> _startSession(AppUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sessionKey, user.id);
    _user = user;
    notifyListeners();
  }
}
