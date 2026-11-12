import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'home_screen.dart';
import 'language_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final locale = context.watch<LocaleProvider>();

    if (auth.isInitializing || locale.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (!locale.hasChosenLanguage) {
      return const LanguageScreen();
    }
    return auth.isLoggedIn ? const HomeScreen() : const LoginScreen();
  }
}
