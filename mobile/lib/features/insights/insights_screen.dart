import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/models.dart';
import '../../core/state/providers.dart';
import '../../core/theme/app_colors.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wasteHistory = ref.watch(wasteProvider);

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waste Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.stone.withOpacity(0.5)),
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
                  const Text('Weekly Waste Score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: 0.78,
                          strokeWidth: 12,
                          backgroundColor: AppColors.stone.withOpacity(0.3),
                          color: AppColors.forest,
                        ),
                      ),
                      const Column(
                        children: [
                          Text('78', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: 'DM Serif Display', color: AppColors.forest)),
                          Text('/ 100', style: TextStyle(fontSize: 12, color: AppColors.slate)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Great! You wasted 15% less than last week.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.slate, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Waste Breakdown
            const Text('Waste Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.stone.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 12,
                      child: Row(
                        children: [
                          Expanded(flex: 40, child: Container(color: AppColors.forest)),
                          Expanded(flex: 30, child: Container(color: AppColors.clay)),
                          Expanded(flex: 30, child: Container(color: AppColors.stone)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [Icon(Icons.circle, size: 10, color: AppColors.forest), SizedBox(width: 4), Text('Vegetables (40%)', style: TextStyle(fontSize: 12))]),
                      Row(children: [Icon(Icons.circle, size: 10, color: AppColors.clay), SizedBox(width: 4), Text('Meat (30%)', style: TextStyle(fontSize: 12))]),
                      Row(children: [Icon(Icons.circle, size: 10, color: AppColors.stone), SizedBox(width: 4), Text('Other (30%)', style: TextStyle(fontSize: 12))]),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Waste History
            const Text('Recent Waste History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wasteHistory.length,
              itemBuilder: (context, index) {
                final log = wasteHistory[index];
                return _buildWasteItem(log);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteItem(WasteLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stone.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: log.status == 'Spoiled' ? AppColors.today.withOpacity(0.1) : AppColors.safe.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              log.status == 'Spoiled' ? Icons.delete_outline : Icons.check_circle_outline,
              color: log.status == 'Spoiled' ? AppColors.today : AppColors.safe,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text('${log.status} • ${log.date}', style: const TextStyle(fontSize: 12, color: AppColors.slate)),
              ],
            ),
          ),
          if (log.cost > 0)
            Text('₱${log.cost.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.today)),
        ],
      ),
    );
  }
}
