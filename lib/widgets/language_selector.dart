import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/theme.dart';
import '../providers/locale_provider.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final lang = localeProvider.language;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: AppColors.emerald),
                const SizedBox(width: 10),
                Text(
                  AppStrings.of(lang, 'language'),
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<AppLanguage>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: AppLanguage.english, label: Text('English')),
                  ButtonSegment(value: AppLanguage.kurdish, label: Text('\u06A9\u0648\u0631\u062F\u06CC')),
                  ButtonSegment(value: AppLanguage.arabic, label: Text('\u0627\u0644\u0639\u0631\u0628\u064A\u0629')),
                ],
                selected: {lang},
                onSelectionChanged: (selection) => localeProvider.setLanguage(selection.first),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
