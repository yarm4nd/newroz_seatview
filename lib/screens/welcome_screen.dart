import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/locale_provider.dart';
import 'auth_gate.dart';
import 'home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  String _welcomeTitle(AppLanguage lang) {
    if (lang == AppLanguage.kurdish) return '\u0628\u06D5\u062E\u06CE\u0631\u0628\u06CE\u0646 \u0628\u06C6 \u06CC\u0627\u0646\u06D5\u06CC \u0646\u06D5\u0648\u0631\u06C6\u0632';
    if (lang == AppLanguage.arabic) return '\u0623\u0647\u0644\u0627\u064B \u0628\u0643\u0645 \u0641\u064A \u0646\u0627\u062F\u064A \u0646\u0648\u0631\u0648\u0632';
    return 'Welcome to Newroz Club';
  }

  String _subtitle(AppLanguage lang) {
    if (lang == AppLanguage.kurdish) {
      return '\u0628\u06B5\u06CC\u062A\u060C \u06CC\u0627\u0631\u06CC\u06CC\u06D5\u06A9\u0627\u0646 \u0648 \u0641\u0631\u06C6\u0634\u06AF\u0627\u06CC \u0641\u06D5\u0631\u0645\u06CC \u06CC\u0627\u0646\u06D5\u06CC \u0646\u06D5\u0648\u0631\u06C6\u0632 • \u0633\u0644\u06CE\u0645\u0627\u0646\u06CC';
    }
    if (lang == AppLanguage.arabic) {
      return '\u0627\u0644\u062A\u0630\u0627\u0643\u0631 \u0648\u0627\u0644\u0645\u0628\u0627\u0631\u064A\u0627\u062A \u0648\u0627\u0644\u0645\u062A\u062C\u0631 \u0627\u0644\u0631\u0633\u0645\u064A \u0644\u0646\u0627\u062F\u064A \u0646\u0648\u0631\u0648\u0632 • \u0627\u0644\u0633\u0644\u064A\u0645\u0627\u0646\u064A\u0629';
    }
    return 'Official Tickets, Fixtures & Club Store • Sulaymaniyah';
  }

  String _startBtn(AppLanguage lang) {
    if (lang == AppLanguage.kurdish) return '\u062F\u06D5\u0633\u062A\u067E\u06CE\u06A9\u0631\u062F\u0646';
    if (lang == AppLanguage.arabic) return '\u0627\u0628\u062F\u0623';
    return 'Start';
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;
    final auth = context.watch<AuthProvider>();
    final name = (auth.user?.name ?? '').trim();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF8B0018), Color(0xFFC8102E), Color(0xFF1A0509)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 142,
                        height: 142,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.emerald,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NEWROZ',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.5),
                              ),
                              SizedBox(height: 2),
                              Icon(Icons.local_fire_department, color: Colors.white, size: 48),
                              SizedBox(height: 2),
                              Text(
                                'SPORTS CLUB',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 8.5, letterSpacing: 1.1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (name.isNotEmpty) ...[
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                    ],
                    Text(
                      _welcomeTitle(lang),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _subtitle(lang),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 36),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.emerald,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                        );
                      },
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: Text(_startBtn(lang), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        await auth.logout();
                        navigator.pushReplacement(
                          MaterialPageRoute<void>(builder: (_) => const AuthGate()),
                        );
                      },
                      child: Text(
                        AppStrings.of(lang, 'log_out'),
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
