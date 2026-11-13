import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/formatters.dart';
import '../core/theme.dart';
import '../core/translator.dart';
import '../models/product.dart';
import '../providers/admin_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../widgets/product_art.dart';
import 'cart_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  ProductCategory? _category;

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LocaleProvider>().language;
    final admin = context.watch<AdminProvider>();
    final cart = context.watch<CartProvider>();
    final products = _category == null ? admin.products : admin.products.where((p) => p.category == _category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.of(lang, 'team_shop')),
        actions: [
          IconButton(
            icon: Badge(isLabelVisible: cart.lines.length > 0, label: Text('${cart.lines.length}'), child: const Icon(Icons.shopping_cart_outlined)),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  ChoiceChip(label: Text(AppStrings.of(lang, 'all')), selected: _category == null, onSelected: (_) => setState(() => _category = null)),
                  for (final c in ProductCategory.values) ...[
                    const SizedBox(width: 8),
                    ChoiceChip(label: Text(Tr.text(lang, c.label)), selected: _category == c, onSelected: (_) => setState(() => _category = c)),
                  ],
                ]),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 220, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.72),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant)),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                          Expanded(child: ProductArt(product: product)),
                          const SizedBox(height: 8),
                          Text(Tr.text(lang, product.name), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(Tr.text(lang, Formatters.currency(product.price)), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800, color: AppColors.emerald)),
                          const SizedBox(height: 6),
                          FilledButton(
                            onPressed: () => cart.add(product, size: product.sizes.isEmpty ? null : product.sizes.first),
                            child: const Icon(Icons.add_shopping_cart, size: 18),
                          ),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
