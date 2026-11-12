import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../core/translator.dart';
import '../models/league_match.dart';
import '../models/product.dart';
import '../providers/admin_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/locale_provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key, required this.onLogout});
  final VoidCallback onLogout;

  static String tr(AppLanguage lang, String en, String ku, String ar) {
    if (lang == AppLanguage.kurdish) return ku;
    if (lang == AppLanguage.arabic) return ar;
    return en;
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocaleProvider>();
    final lang = locale.language;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(lang, 'Admin Panel', '\u067E\u06D5\u0646\u06CE\u06B5\u06CC \u0628\u06D5\u0695\u06CE\u0648\u06D5\u0628\u06D5\u0631', '\u0644\u0648\u062D\u0629 \u0627\u0644\u062A\u062D\u0643\u0645')),
          actions: [
            PopupMenuButton<AppLanguage>(
              icon: const Icon(Icons.language),
              onSelected: locale.setLanguage,
              itemBuilder: (_) => const [
                PopupMenuItem(value: AppLanguage.english, child: Text('English')),
                PopupMenuItem(value: AppLanguage.kurdish, child: Text('\u06A9\u0648\u0631\u062F\u06CC (\u0633\u06C6\u0631\u0627\u0646\u06CC)')),
                PopupMenuItem(value: AppLanguage.arabic, child: Text('\u0627\u0644\u0639\u0631\u0628\u064A\u0629')),
              ],
            ),
            IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: tr(lang, 'Money', '\u062F\u0627\u0647\u0627\u062A', '\u0627\u0644\u0625\u064A\u0631\u0627\u062F\u0627\u062A')),
              Tab(text: tr(lang, 'Matches & Goals', '\u06CC\u0627\u0631\u06CC \u0648 \u06AF\u06C6\u06B5', '\u0627\u0644\u0645\u0628\u0627\u0631\u064A\u0627\u062A \u0648\u0627\u0644\u0623\u0647\u062F\u0627\u0641')),
              Tab(text: tr(lang, 'Clothes & Shop', '\u062C\u0644\u0648\u0628\u06D5\u0631\u06AF \u0648 \u0641\u0631\u06C6\u0634\u06AF\u0627', '\u0627\u0644\u0645\u0644\u0627\u0628\u0633 \u0648\u0627\u0644\u0645\u062A\u062C\u0631')),
              Tab(text: tr(lang, 'Post News', '\u0628\u06B5\u0627\u0648\u06A9\u0631\u062F\u0646\u06D5\u0648\u06D5\u06CC \u0647\u06D5\u0648\u0627\u06B5', '\u0646\u0634\u0631 \u0627\u0644\u0623\u062E\u0628\u0627\u0631')),
              Tab(text: tr(lang, 'Tickets', '\u0628\u0644\u06CC\u062A\u06D5\u06A9\u0627\u0646', '\u0627\u0644\u062A\u0630\u0627\u0643\u0631')),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MoneyTab(),
            _MatchesGoalsTab(),
            _ClothesShopTab(),
            _PostNewsTab(),
            _TicketsTab(),
          ],
        ),
      ),
    );
  }
}

class _MoneyTab extends StatelessWidget {
  const _MoneyTab();

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();
    final admin = context.watch<AdminProvider>();
    final lang = context.watch<LocaleProvider>().language;
    final ticketMoney = booking.tickets.fold<int>(0, (s, t) => s + t.price);
    final clothesMoney = admin.shopRevenue;
    final total = ticketMoney + clothesMoney;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatTile(Icons.account_balance_wallet, AdminScreen.tr(lang, 'Total Revenue', '\u06A9\u06C6\u06CC \u06AF\u0634\u062A\u06CC \u062F\u0627\u0647\u0627\u062A', '\u0625\u062C\u0645\u0627\u0644\u064A \u0627\u0644\u0625\u064A\u0631\u0627\u062F\u0627\u062A'), Tr.text(lang, Formatters.currency(total)), AppColors.emerald),
        const SizedBox(height: 12),
        _StatTile(Icons.confirmation_number, '${AdminScreen.tr(lang, 'Ticket Sales', '\u062F\u0627\u0647\u0627\u062A\u06CC \u0628\u0644\u06CC\u062A', '\u0645\u0628\u064A\u0639\u0627\u062A \u0627\u0644\u062A\u0630\u0627\u0643\u0631')} (${booking.tickets.length})', Tr.text(lang, Formatters.currency(ticketMoney)), Colors.blue),
        const SizedBox(height: 12),
        _StatTile(Icons.checkroom, '${AdminScreen.tr(lang, 'Clothes & Shop Sales', '\u062F\u0627\u0647\u0627\u062A\u06CC \u062C\u0644\u0648\u0628\u06D5\u0631\u06AF', '\u0645\u0628\u064A\u0639\u0627\u062A \u0627\u0644\u0645\u0644\u0627\u0628\u0633')} (${admin.shopOrders})', Tr.text(lang, Formatters.currency(clothesMoney)), AppColors.gold),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile(this.icon, this.label, this.value, this.color);
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.15), child: Icon(icon, color: color)),
        title: Text(label),
        subtitle: Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
      ),
    );
  }
}
class _MatchesGoalsTab extends StatelessWidget {
  const _MatchesGoalsTab();

  void _addMatchDialog(BuildContext context, AdminProvider admin, AppLanguage lang) {
    final homeCtrl = TextEditingController(text: 'Newroz');
    final awayCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AdminScreen.tr(lang, 'Add New Match', '\u0632\u06CC\u0627\u062F\u06A9\u0631\u062F\u0646\u06CC \u06CC\u0627\u0631\u06CC \u0646\u0648\u06CE', '\u0625\u0636\u0627\u0641\u0629 \u0645\u0628\u0627\u0631\u0627\u0629 \u062C\u062F\u064A\u062F\u0629')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: homeCtrl, decoration: InputDecoration(labelText: AdminScreen.tr(lang, 'Home Team', '\u062A\u06CC\u067E\u06CC \u06CC\u0627\u0631\u06CC\u06AF\u0627', '\u0627\u0644\u0641\u0631\u064A\u0642 \u0627\u0644\u0645\u0636\u064A\u0641'))),
          TextField(controller: awayCtrl, decoration: InputDecoration(labelText: AdminScreen.tr(lang, 'Away Team', '\u062A\u06CC\u067E\u06CC \u0645\u06CC\u0648\u0627\u0646', '\u0627\u0644\u0641\u0631\u064A\u0642 \u0627\u0644\u0636\u064A\u0641'))),
        ]),
        actions: [
          FilledButton(
            onPressed: () {
              if (homeCtrl.text.trim().isNotEmpty && awayCtrl.text.trim().isNotEmpty) {
                admin.addMatch(home: homeCtrl.text.trim(), away: awayCtrl.text.trim(), kickoff: DateTime.now().add(const Duration(days: 3)));
                Navigator.pop(context);
              }
            },
            child: Text(AdminScreen.tr(lang, 'Add', '\u0632\u06CC\u0627\u062F\u06A9\u0631\u062F\u0646', '\u0625\u0636\u0627\u0641\u0629')),
          ),
        ],
      ),
    );
  }

  void _setGoalsDialog(BuildContext context, AdminProvider admin, LeagueMatch m, AppLanguage lang) {
    final hCtrl = TextEditingController(text: '0');
    final aCtrl = TextEditingController(text: '0');
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${Tr.text(lang, m.home)} vs ${Tr.text(lang, m.away)}'),
        content: Row(children: [
          Expanded(child: TextField(controller: hCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: Tr.text(lang, m.home)))),
          const SizedBox(width: 12),
          Expanded(child: TextField(controller: aCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: Tr.text(lang, m.away)))),
        ]),
        actions: [
          FilledButton(
            onPressed: () {
              admin.setScore(m, int.tryParse(hCtrl.text) ?? 0, int.tryParse(aCtrl.text) ?? 0);
              Navigator.pop(context);
            },
            child: Text(AdminScreen.tr(lang, 'Save Goals', '\u067E\u0627\u0634\u06D5\u06A9\u06D5\u0648\u062A\u06A9\u0631\u062F\u0646\u06CC \u06AF\u06C6\u06B5\u06D5\u06A9\u0627\u0646', '\u062D\u0641\u0638 \u0627\u0644\u0623\u0647\u062F\u0627\u0641')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final lang = context.watch<LocaleProvider>().language;
    final newrozMatches = admin.matches.where((m) => m.involvesNewroz).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: () => _addMatchDialog(context, admin, lang),
          icon: const Icon(Icons.add),
          label: Text(AdminScreen.tr(lang, 'Add New Match', '\u0632\u06CC\u0627\u062F\u06A9\u0631\u062F\u0646\u06CC \u06CC\u0627\u0631\u06CC \u0646\u0648\u06CE', '\u0625\u0636\u0627\u0641\u0629 \u0645\u0628\u0627\u0631\u0627\u0629 \u062C\u062F\u064A\u062F\u0629')),
        ),
        const SizedBox(height: 12),
        for (final m in newrozMatches)
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            child: ListTile(
              title: Text('${Tr.text(lang, m.home)} vs ${Tr.text(lang, m.away)}', style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text('${DateFormat('d MMM').format(m.kickoff)} • ${admin.scoreFor(m) ?? AdminScreen.tr(lang, 'No goals yet', '\u0647\u06CE\u0634\u062A\u0627 \u06AF\u06C6\u06B5 \u062A\u06C6\u0645\u0627\u0631 \u0646\u06D5\u06A9\u0631\u0627\u0648\u06D5', '\u0644\u0627 \u062A\u0648\u062C\u062F \u0623\u0647\u062F\u0627\u0641 \u0628\u0639\u062F')}'),
              trailing: OutlinedButton(
                onPressed: () => _setGoalsDialog(context, admin, m, lang),
                child: Text(AdminScreen.tr(lang, 'Goals', '\u06AF\u06C6\u06B5', '\u0627\u0644\u0623\u0647\u062F\u0627\u0641')),
              ),
            ),
          ),
      ],
    );
  }
}

class _ClothesShopTab extends StatelessWidget {
  const _ClothesShopTab();

  void _addClothesDialog(BuildContext context, AdminProvider admin, AppLanguage lang) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AdminScreen.tr(lang, 'Add Clothes / Item', '\u0632\u06CC\u0627\u062F\u06A9\u0631\u062F\u0646\u06CC \u062C\u0644\u0648\u0628\u06D5\u0631\u06AF', '\u0625\u0636\u0627\u0641\u0629 \u0645\u0644\u0627\u0628\u0633 / \u0645\u0646\u062A\u062C')),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: nameCtrl, decoration: InputDecoration(labelText: AdminScreen.tr(lang, 'Item Name', '\u0646\u0627\u0648\u06CC \u06A9\u0627\u06B5\u0627', '\u0627\u0633\u0645 \u0627\u0644\u0645\u0646\u062A\u062C'))),
          TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: AdminScreen.tr(lang, 'Price (IQD)', '\u0646\u0631\u062E (\u062F\u06CC\u0646\u0627\u0631)', '\u0627\u0644\u0633\u0639\u0631 (\u062F.\u0639)'))),
        ]),
        actions: [
          FilledButton(
            onPressed: () {
              final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
              if (nameCtrl.text.trim().isNotEmpty && price > 0) {
                admin.addProduct(name: nameCtrl.text.trim(), category: ProductCategory.apparel, price: price, description: 'Official Newroz SC club item.');
                Navigator.pop(context);
              }
            },
            child: Text(AdminScreen.tr(lang, 'Add', '\u0632\u06CC\u0627\u062F\u06A9\u0631\u062F\u0646', '\u0625\u0636\u0627\u0641\u0629')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final lang = context.watch<LocaleProvider>().language;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FilledButton.icon(
          onPressed: () => _addClothesDialog(context, admin, lang),
          icon: const Icon(Icons.add_shopping_cart),
          label: Text(AdminScreen.tr(lang, 'Add New Clothes / Item', '\u0632\u06CC\u0627\u062F\u06A9\u0631\u062F\u0646\u06CC \u062C\u0644\u0648\u0628\u06D5\u0631\u06AF\u06CC \u0646\u0648\u06CE', '\u0625\u0636\u0627\u0641\u0629 \u0645\u0644\u0627\u0628\u0633 \u062C\u062F\u064A\u062F\u0629')),
        ),
        const SizedBox(height: 12),
        for (final p in admin.products)
          Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: p.color, child: Icon(p.icon, color: Colors.white, size: 18)),
              title: Text(Tr.text(lang, p.name), style: const TextStyle(fontWeight: FontWeight.w700)),
              subtitle: Text(Tr.text(lang, p.category.label)),
              trailing: Text(Tr.text(lang, Formatters.currency(p.price)), style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.emerald)),
            ),
          ),
      ],
    );
  }
}

class _PostNewsTab extends StatefulWidget {
  const _PostNewsTab();
  @override
  State<_PostNewsTab> createState() => _PostNewsTabState();
}

class _PostNewsTabState extends State<_PostNewsTab> {
  final _titleCtrl = TextEditingController();
  final _bodyCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final admin = context.watch<AdminProvider>();
    final lang = context.watch<LocaleProvider>().language;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(controller: _titleCtrl, decoration: InputDecoration(labelText: AdminScreen.tr(lang, 'News Title', '\u0646\u0627\u0648\u0646\u06CC\u0634\u0627\u0646\u06CC \u0647\u06D5\u0648\u0627\u06B5', '\u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u062E\u0628\u0631'), border: const OutlineInputBorder())),
        const SizedBox(height: 12),
        TextField(controller: _bodyCtrl, maxLines: 4, decoration: InputDecoration(labelText: AdminScreen.tr(lang, 'News Details', '\u062F\u0631\u06CE\u0698\u06D5\u06CC \u0647\u06D5\u0648\u0627\u06B5', '\u062A\u0641\u0627\u0635\u064A\u0644 \u0627\u0644\u062E\u0628\u0631'), border: const OutlineInputBorder())),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () {
            if (_titleCtrl.text.trim().isNotEmpty && _bodyCtrl.text.trim().isNotEmpty) {
              admin.addNews(tag: 'Club News', title: _titleCtrl.text.trim(), summary: _bodyCtrl.text.trim(), body: _bodyCtrl.text.trim());
              _titleCtrl.clear();
              _bodyCtrl.clear();
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AdminScreen.tr(lang, 'News published!', '\u0647\u06D5\u0648\u0627\u06B5\u06D5\u06A9\u06D5 \u0628\u06B5\u0627\u0648\u06A9\u0631\u0627\u06CC\u06D5\u0648\u06D5!', '\u062A\u0645 \u0646\u0634\u0631 \u0627\u0644\u062E\u0628\u0631!'))));
}
},
icon: const Icon(Icons.publish),
label: Text(AdminScreen.tr(lang, 'Publish News', '\u0628\u06B5\u0627\u0648\u06A9\u0631\u062F\u0646\u06D5\u0648\u06D5', '\u0646\u0634\u0631 \u0627\u0644\u062E\u0628\u0631')),
),
const SizedBox(height: 20),
for (final item in admin.news)
Card(
elevation: 0,
margin: const EdgeInsets.only(bottom: 8),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
child: ListTile(title: Text(Tr.text(lang, item.title), style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text(Tr.text(lang, item.summary))),
),
],
);
}
}
class _TicketsTab extends StatelessWidget {
const _TicketsTab();
@override
Widget build(BuildContext context) {
final booking = context.watch();
final lang = context.watch().language;
return ListView(
padding: const EdgeInsets.all(16),
children: [
for (final t in booking.tickets)
Card(
elevation: 0,
margin: const EdgeInsets.only(bottom: 8),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
child: ListTile(
title: Text('${t.holderName} • ${t.code}'),
subtitle: Text('${Tr.text(lang, t.section.name)} • ${Tr.text(lang, 'Row')} ${t.row} • ${Tr.text(lang, 'Seat')} ${t.seatNumber}'),
trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => booking.cancelTicket(t)),
),
),
],
);
}
}
