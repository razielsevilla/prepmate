import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/models.dart';
import '../../core/state/providers.dart';
import '../../core/theme/app_colors.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shoppingList = ref.watch(shoppingListProvider);

    final marketItems = shoppingList.where((item) => item.type == 'market').toList();
    final superMarketItems = shoppingList.where((item) => item.type == 'supermarket').toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Shopping Gap List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (marketItems.isNotEmpty) ...[
                  const Text('Palengke / Wet Market', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  ...marketItems.map((item) => _buildShoppingItem(context, ref, item)),
                  const SizedBox(height: 24),
                ],
                if (superMarketItems.isNotEmpty) ...[
                  const Text('Supermarket', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  ...superMarketItems.map((item) => _buildShoppingItem(context, ref, item)),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Action to add checked items to pantry
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bought items added to Pantry!'),
                      backgroundColor: AppColors.forest,
                    ),
                  );
                },
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Add bought items to Pantry', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingItem(BuildContext context, WidgetRef ref, ShoppingItem item) {
    return GestureDetector(
      onTap: () {
        ref.read(shoppingListProvider.notifier).toggleCheck(item.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: item.checked ? AppColors.forest : AppColors.stone),
        ),
        child: Row(
          children: [
            Icon(
              item.checked ? Icons.check_circle : Icons.circle_outlined,
              color: item.checked ? AppColors.forest : AppColors.stone,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: item.checked ? FontWeight.normal : FontWeight.w600,
                  color: item.checked ? AppColors.slate : AppColors.soil,
                  decoration: item.checked ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
