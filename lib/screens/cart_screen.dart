import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_strings.dart';
import '../core/formatters.dart';
import '../core/translator.dart';
import '../providers/admin_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/membership_provider.dart';
import '../widgets/product_art.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final admin = context.read<AdminProvider>();
    final userId = context.watch<AuthProvider>().user?.id;
    final tier = context.watch<MembershipProvider>().tierFor(userId);
    final lang = context.watch<LocaleProvider>().language;
    final percent = tier?.shopDiscountPercent ?? 0;
    final lines = cart.lines;
    final total = cart.subtotal - cart.discountFor(percent);
    final theme = Theme.of(context);

    final emptyText = lang == AppLanguage.kurdish ? '\u0633\u06D5\u0628\u06D5\u062A\u06D5\u06A9\u06D5\u062A \u0628\u06D5\u062A\u0627\u06B5\u06D5' : lang == AppLanguage.arabic ? '\u0633\u0644\u062A\u0643 \u0641\u0627\u0631\u063A\u0629' : 'Your cart is empty';
    final totalLabel = lang == AppLanguage.kurdish ? '\u06A9\u06C6\u06CC \u06AF\u0634\u062A\u06CC' : lang == AppLanguage.arabic ? '\u0627\u0644\u0645\u062C\u0645\u0648\u0639' : 'Total';
    final orderBtn = lang == AppLanguage.kurdish ? '\u062A\u06D5\u0648\u0627\u0648\u06A9\u0631\u062F\u0646\u06CC \u062F\u0627\u0648\u0627\u06A9\u0627\u0631\u06CC' : lang == AppLanguage.arabic ? '\u0625\u062A\u0645\u0627\u0645 \u0627\u0644\u0637\u0644\u0628' : 'Place order';

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.of(lang, 'my_cart'))),
      body: lines.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.shopping_cart_outlined, size: 64, color: theme.colorScheme.outline), const SizedBox(height: 12), Text(emptyText, style: theme.textTheme.titleMedium)]))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final line = lines[index];
                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant)),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(children: [
                          SizedBox(width: 64, height: 64, child: ProductArt(product: line.product, iconSize: 28, radius: 12)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(Tr.text(lang, line.product.name), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                            if (line.size != null) Text('${line.size}', style: theme.textTheme.bodySmall),
                            Text(Tr.text(lang, Formatters.currency(line.total)), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800)),
                          ])),
                          IconButton(onPressed: () => cart.decrease(line.key), icon: const Icon(Icons.remove_circle_outline)),
                          Text('${line.quantity}', style: theme.textTheme.titleSmall),
                          IconButton(onPressed: () => cart.increase(line.key), icon: const Icon(Icons.add_circle_outline)),
                        ]),
                      ),
                    );
                  },
                ),
              ),
            ),
      bottomNavigationBar: lines.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(totalLabel, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)), Text(Tr.text(lang, Formatters.currency(total)), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800))]),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () {
                      admin.recordShopOrder(total);
                      cart.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text(orderBtn),
                  ),
                ]),
              ),
            ),
    );
  }
}
