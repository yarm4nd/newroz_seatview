import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/formatters.dart';
import '../core/theme.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/membership_provider.dart';
import '../widgets/product_art.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _placeOrder(BuildContext context, int total) async {
    final cart = context.read<CartProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Place order?'),
        content: Text(
          'Total: ${Formatters.currency(total)}\n\n'
          'Demo mode: no payment is taken and the order is not sent anywhere yet.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Back'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Place order'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    cart.clear();
    navigator.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Order placed. Thank you!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final userId = context.watch<AuthProvider>().user?.id;
    final tier = context.watch<MembershipProvider>().tierFor(userId);
    final percent = tier?.shopDiscountPercent ?? 0;

    final lines = cart.lines;
    final discount = cart.discountFor(percent);
    final total = cart.subtotal - discount;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
        actions: [
          if (lines.isNotEmpty)
            TextButton(onPressed: cart.clear, child: const Text('Clear')),
        ],
      ),
      body: lines.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text('Your cart is empty',
                      style: theme.textTheme.titleMedium),
                ],
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: lines.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) =>
                      _CartLineTile(line: lines[index]),
                ),
              ),
            ),
      bottomNavigationBar: lines.isEmpty
          ? null
          : SafeArea(
              child: Center(
                heightFactor: 1,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SummaryRow(
                          label: 'Subtotal',
                          value: Formatters.currency(cart.subtotal),
                        ),
                        if (percent > 0) ...[
                          const SizedBox(height: 4),
                          _SummaryRow(
                            label: '${tier!.label} discount ($percent%)',
                            value: '−${Formatters.currency(discount)}',
                            color: AppColors.green,
                          ),
                        ],
                        const SizedBox(height: 8),
                        _SummaryRow(
                          label: 'Total',
                          value: Formatters.currency(total),
                          bold: true,
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () => _placeOrder(context, total),
                          child: const Text('Place order'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.read<CartProvider>();

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child:
                  ProductArt(product: line.product, iconSize: 28, radius: 12),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (line.size != null)
                    Text('Size ${line.size}', style: theme.textTheme.bodySmall),
                  Text(
                    Formatters.currency(line.total),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Remove one',
              onPressed: () => cart.decrease(line.key),
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text('${line.quantity}', style: theme.textTheme.titleSmall),
            IconButton(
              tooltip: 'Add one',
              onPressed: () => cart.increase(line.key),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.color,
  });

  final String label;
  final String value;
  final bool bold;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: bold ? FontWeight.w800 : FontWeight.w400,
          color: color,
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(value, style: style)],
    );
  }
}
