import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/theme.dart';
import '../core/translator.dart';
import '../data/news.dart';
import '../models/news_item.dart';
import '../providers/locale_provider.dart';

final DateFormat _dateFormat = DateFormat('d MMM y');

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'news'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [for (final item in NewsData.all) NewsCard(item: item)],
          ),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.item});
  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocaleProvider>().language;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => NewsDetailScreen(item: item))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(Tr.text(lang, item.tag).toUpperCase(), style: theme.textTheme.labelSmall?.copyWith(color: AppColors.emerald, fontWeight: FontWeight.w800, letterSpacing: 1)),
                const Spacer(),
                Text(Tr.text(lang, _dateFormat.format(item.date)), style: theme.textTheme.labelSmall),
              ]),
              const SizedBox(height: 8),
              Text(Tr.text(lang, item.title), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(Tr.text(lang, item.summary), style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsDetailScreen extends StatelessWidget {
  const NewsDetailScreen({super.key, required this.item});
  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<LocaleProvider>().language;
    return Scaffold(
      appBar: AppBar(title: Text(Tr.text(lang, item.tag))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(Tr.text(lang, item.title), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(Tr.text(lang, _dateFormat.format(item.date)), style: theme.textTheme.labelMedium),
              const SizedBox(height: 16),
              Text(Tr.text(lang, item.body), style: theme.textTheme.bodyLarge?.copyWith(height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}
