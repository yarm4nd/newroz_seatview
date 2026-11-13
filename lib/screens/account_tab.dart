import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/app_strings.dart';
import '../core/theme.dart';
import '../core/translator.dart';
import '../providers/auth_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/membership_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/language_selector.dart';
import 'auth_gate.dart';
import 'cart_screen.dart';
import 'membership_screen.dart';
import 'tickets_screen.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key, this.onNavigate});
  final ValueChanged<int>? onNavigate;

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  Uint8List? _photoBytes;
  int? _loadedUserId;

  String _tr(AppLanguage lang, String en, String ku, String ar) {
    if (lang == AppLanguage.kurdish) return ku;
    if (lang == AppLanguage.arabic) return ar;
    return en;
  }

  String _photoKey(int userId) => 'profile_photo_$userId';

  Future<void> _loadPhoto(int? userId) async {
    if (userId == null || userId == _loadedUserId) return;
    _loadedUserId = userId;
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_photoKey(userId));
    if (!mounted) return;
    setState(() {
      _photoBytes = (encoded != null && encoded.isNotEmpty) ? base64Decode(encoded) : null;
    });
  }

  Future<void> _pickPhoto(int? userId, AppLanguage lang) async {
    if (userId == null) return;
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery, maxWidth: 512, imageQuality: 85);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_photoKey(userId), base64Encode(bytes));
    if (!mounted) return;
    setState(() => _photoBytes = bytes);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _tr(
            lang,
            'Profile photo updated!',
            '\u0648\u06CE\u0646\u06D5\u06CC \u067E\u0695\u06C6\u0641\u0627\u06CC\u0644 \u0646\u0648\u06CE\u06A9\u0631\u0627\u06CC\u06D5\u0648\u06D5!',
            '\u062A\u0645 \u062A\u062D\u062F\u064A\u062B \u0635\u0648\u0631\u0629 \u0627\u0644\u0645\u0644\u0641 \u0627\u0644\u0634\u062E\u0635\u064A!',
          ),
        ),
      ),
    );
  }

  Future<void> _removePhoto(int? userId) async {
    if (userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_photoKey(userId));
    if (!mounted) return;
    setState(() => _photoBytes = null);
  }

  void _openPhotoMenu(int? userId, AppLanguage lang) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.emerald),
              title: Text(_tr(lang, 'Choose profile photo', '\u0647\u06D5\u06B5\u0628\u0698\u0627\u0631\u062F\u0646\u06CC \u0648\u06CE\u0646\u06D5\u06CC \u067E\u0695\u06C6\u0641\u0627\u06CC\u0644', '\u0627\u062E\u062A\u064A\u0627\u0631 \u0635\u0648\u0631\u0629 \u0627\u0644\u0645\u0644\u0641 \u0627\u0644\u0634\u062E\u0635\u064A')),
              onTap: () {
                Navigator.pop(ctx);
                _pickPhoto(userId, lang);
              },
            ),
            if (_photoBytes != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
                title: Text(_tr(lang, 'Remove photo', '\u0633\u0695\u06CC\u0646\u06D5\u0648\u06D5\u06CC \u0648\u06CE\u0646\u06D5', '\u0625\u0632\u0627\u0644\u0629 \u0627\u0644\u0635\u0648\u0631\u0629')),
                onTap: () {
                  Navigator.pop(ctx);
                  _removePhoto(userId);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context, AppLanguage lang) async {
    final auth = context.read<AuthProvider>();
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppStrings.of(lang, 'log_out')),
        content: Text(
          _tr(
            lang,
            'Are you sure you want to log out of your account?',
            '\u062F\u06B5\u0646\u06CC\u0627\u06CC\u062A \u062F\u06D5\u062A\u06D5\u0648\u06CE\u062A \u0644\u06D5 \u0647\u06D5\u0698\u0645\u0627\u0631\u06D5\u06A9\u06D5\u062A \u0628\u0686\u06CC\u062A\u06D5 \u062F\u06D5\u0631\u06D5\u0648\u06D5\u061F',
            '\u0647\u0644 \u0623\u0646\u062A \u0645\u062A\u0623\u0643\u062F \u0623\u0646\u0643 \u062A\u0631\u064A\u062F \u062A\u0633\u062C\u064A\u0644 \u0627\u0644\u062E\u0631\u0648\u062C \u0645\u0646 \u062D\u0633\u0627\u0628\u0643\u061F',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(_tr(lang, 'Cancel', '\u067E\u06D5\u0634\u06CC\u0645\u0627\u0646\u0628\u0648\u0648\u0646\u06D5\u0648\u06D5', '\u0625\u0644\u063A\u0627\u0621')),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(AppStrings.of(lang, 'log_out')),
          ),
        ],
      ),
    );
    if (ok == true) {
      await auth.logout();
      navigator.pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (ctx) => const AuthGate()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    _loadPhoto(user?.id);

    final tickets = context.watch<BookingProvider>().tickets;
    final cartCount = context.watch<CartProvider>().lines.length;
    final tier = context.watch<MembershipProvider>().tierFor(user?.id);
    final themeProvider = context.watch<ThemeProvider>();
    final lang = context.watch<LocaleProvider>().language;

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'account'))),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _openPhotoMenu(user?.id, lang),
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 32,
                              backgroundColor: AppColors.emerald,
                              backgroundImage: _photoBytes != null ? MemoryImage(_photoBytes!) : null,
                              child: _photoBytes == null ? const Icon(Icons.person, color: Colors.white, size: 32) : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.emerald, width: 1.5),
                                ),
                                child: const Icon(Icons.camera_alt, size: 14, color: AppColors.emerald),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? '', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                            Text(user?.phone ?? '', style: theme.textTheme.bodySmall),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (tier?.color ?? AppColors.emerald).withValues(alpha: 0.14),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    tier != null ? Tr.text(lang, tier.label) : AppStrings.of(lang, 'free_fan'),
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tier?.color ?? AppColors.emerald),
),
),
const SizedBox(width: 8),
InkWell(
onTap: () => _openPhotoMenu(user?.id, lang),
child: Text(
_tr(lang, 'Edit photo', '\u06AF\u06C6\u0695\u06CC\u0646\u06CC \u0648\u06CE\u0646\u06D5', '\u062A\u063A\u064A\u064A\u0631 \u0627\u0644\u0635\u0648\u0631\u0629'),
style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.emerald),
),
),
],
),
],
),
),
],
),
),
),
const SizedBox(height: 16),
const LanguageSelector(),
const SizedBox(height: 16),
Card(
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
const Icon(Icons.brightness_6_outlined, color: AppColors.emerald),
const SizedBox(width: 10),
Text(AppStrings.of(lang, 'appearance'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
],
),
const SizedBox(height: 12),
SizedBox(
width: double.infinity,
child: SegmentedButton(
showSelectedIcon: false,
segments: [
ButtonSegment(value: ThemeMode.light, label: Text(AppStrings.of(lang, 'light'))),
ButtonSegment(value: ThemeMode.dark, label: Text(AppStrings.of(lang, 'dark'))),
ButtonSegment(value: ThemeMode.system, label: Text(AppStrings.of(lang, 'system'))),
],
selected: {themeProvider.mode},
onSelectionChanged: (s) => themeProvider.setMode(s.first),
),
),
],
),
),
),
const SizedBox(height: 16),
Card(
elevation: 0,
margin: EdgeInsets.zero,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
side: BorderSide(color: theme.colorScheme.outlineVariant),
),
child: Column(
children: [
ListTile(
leading: const Icon(Icons.confirmation_number_outlined, color: AppColors.emerald),
title: Text(AppStrings.of(lang, 'my_tickets')),
trailing: Text('${tickets.length}', style: const TextStyle(fontWeight: FontWeight.w800)),
onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const TicketsScreen())),
),
const Divider(height: 1),
ListTile(
leading: const Icon(Icons.shopping_cart_outlined, color: AppColors.emerald),
title: Text(AppStrings.of(lang, 'my_cart')),
trailing: Text('$cartCount', style: const TextStyle(fontWeight: FontWeight.w800)),
onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const CartScreen())),
),
const Divider(height: 1),
ListTile(
leading: const Icon(Icons.workspace_premium_outlined, color: AppColors.emerald),
title: Text(AppStrings.of(lang, 'membership')),
trailing: const Icon(Icons.chevron_right),
onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const MembershipScreen())),
),
],
),
),
const SizedBox(height: 20),
OutlinedButton.icon(
style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
onPressed: () => _confirmLogout(context, lang),
icon: const Icon(Icons.logout),
label: Text(AppStrings.of(lang, 'log_out')),
),
],
),
),
),
);
}
}
