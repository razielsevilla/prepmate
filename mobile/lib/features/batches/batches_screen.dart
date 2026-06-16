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
      appBar: AppBar(
        title: const Text('Batches'),
      ),
      body: batches.isEmpty
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
                    SizedBox(height: 8),
                    Text(
                      'Complete your first prep plan to start tracking meals here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.slate),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: batches.length,
              itemBuilder: (context, index) {
                final batch = batches[index];
                return _buildBatchCard(context, ref, batch);
              },
            ),
    );
  }

  Widget _buildBatchCard(BuildContext context, WidgetRef ref, PreppedBatch batch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stone),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.restaurant, color: AppColors.forest),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(batch.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                      '${batch.portions} portions left • Cooked ${batch.daysLeft} days ago',
                      style: const TextStyle(color: AppColors.slate, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(batchesProvider.notifier).consumePortion(batch.id);
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('Eat 1 Portion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.forest.withOpacity(0.1),
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
