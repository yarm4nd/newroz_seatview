import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme.dart';
import '../providers/locale_provider.dart';
import 'auth_gate.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  AppLanguage _selected = AppLanguage.english;

  String _continueLabel(AppLanguage lang) {
    if (lang == AppLanguage.kurdish) return '\u0628\u06D5\u0631\u062F\u06D5\u0648\u0627\u0645\u0628\u06D5';
    if (lang == AppLanguage.arabic) return '\u0645\u062A\u0627\u0628\u0639\u0629';
    return 'Continue';
  }

  Future<void> _next() async {
    final locale = context.read<LocaleProvider>();
    final navigator = Navigator.of(context);
    await locale.setLanguage(_selected);
    navigator.pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AuthGate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 78,
                          height: 78,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [AppColors.crimsonDark, AppColors.emerald],
                            ),
                          ),
                          child: const Icon(Icons.language, color: Colors.white, size: 40),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Select Language',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\u0632\u0645\u0627\u0646 \u0647\u06D5\u06B5\u0628\u0698\u06CE\u0631\u06D5  •  \u0627\u062E\u062A\u0631 \u0627\u0644\u0644\u063A\u0629',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      for (final lang in AppLanguage.values)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => setState(() => _selected = lang),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: _selected == lang ? AppColors.emerald.withValues(alpha: 0.12) : Colors.transparent,
                                border: Border.all(
                                  color: _selected == lang ? AppColors.emerald : theme.colorScheme.outlineVariant,
                                  width: _selected == lang ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _selected == lang ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                    color: _selected == lang ? AppColors.emerald : theme.colorScheme.outline,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      lang.label,
                                      style: TextStyle(fontSize: 16, fontWeight: _selected == lang ? FontWeight.w800 : FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: _next,
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(_continueLabel(_selected)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
