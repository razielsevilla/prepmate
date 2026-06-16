import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/models.dart';
import '../../core/state/providers.dart';
import '../../core/theme/app_colors.dart';

class BatchesScreen extends ConsumerWidget {
  const BatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final batches = ref.watch(batchesProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.cream.withValues(alpha: 0.9),
                border: Border(bottom: BorderSide(color: AppColors.stone.withValues(alpha: 0.2))),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Prepped Batches',
                        style: TextStyle(
                          fontFamily: 'DM Serif Display',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.forest,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.mist,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${batches.length} batches',
                          style: const TextStyle(
                            color: AppColors.forest,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Track your prepped meals and decrement portions as you eat.',
                    style: TextStyle(
                      color: AppColors.slate,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: batches.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.kitchen, size: 48, color: AppColors.stone),
                            SizedBox(height: 16),
                            Text(
                              'No active batches',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.soil),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      itemCount: batches.length,
                      itemBuilder: (context, index) {
                        final batch = batches[index];
                        return _buildBatchCard(context, ref, batch);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchCard(BuildContext context, WidgetRef ref, PreppedBatch batch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2EB), // slightly darker cream card bg
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stone.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batch.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.soil,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.clay, // Orange dot
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${batch.daysLeft} days left',
                          style: const TextStyle(color: AppColors.slate, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.stone.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${batch.portions} Portions',
                  style: const TextStyle(
                    color: AppColors.soil,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(batchesProvider.notifier).consumePortion(batch.id);
              },
              icon: const Icon(Icons.restaurant, size: 16),
              label: const Text(
                'Eat 1 Portion',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest.withValues(alpha: 0.1),
                foregroundColor: AppColors.forest,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
