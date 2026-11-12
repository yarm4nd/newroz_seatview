import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import 'account_tab.dart';
import 'home_tab.dart';
import 'matches_screen.dart';
import 'membership_screen.dart';
import 'shop_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  void _go(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().count;
    final lang = context.watch<LocaleProvider>().language;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeTab(onNavigate: _go),
          const MatchesScreen(),
          const ShopScreen(),
          const MembershipScreen(),
          AccountTab(onNavigate: _go),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppStrings.of(lang, 'home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.sports_soccer_outlined),
            selectedIcon: const Icon(Icons.sports_soccer),
            label: AppStrings.of(lang, 'matches'),
          ),
          NavigationDestination(
            icon: Badge.count(
              count: cartCount,
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.storefront_outlined),
            ),
            selectedIcon: Badge.count(
              count: cartCount,
              isLabelVisible: cartCount > 0,
              child: const Icon(Icons.storefront),
            ),
            label: AppStrings.of(lang, 'shop'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.workspace_premium_outlined),
            selectedIcon: const Icon(Icons.workspace_premium),
            label: AppStrings.of(lang, 'membership'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: AppStrings.of(lang, 'account'),
          ),
        ],
      ),
    );
  }
}
