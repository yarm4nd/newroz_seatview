import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// Salted and iterated SHA-256 hashing. Passwords are never stored as text.
class PasswordHasher {
  const PasswordHasher._();

  static const int _iterations = 10000;

  static String generateSalt([int length = 16]) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  static String hash(String password, String salt) {
    final saltBytes = utf8.encode(salt);
    var digest = sha256.convert([...saltBytes, ...utf8.encode(password)]).bytes;
    for (var i = 0; i < _iterations; i++) {
      digest = sha256.convert([...digest, ...saltBytes]).bytes;
    }
    return base64UrlEncode(digest);
  }

  static bool verify(String password, String salt, String expectedHash) =>
      hash(password, salt) == expectedHash;
}
