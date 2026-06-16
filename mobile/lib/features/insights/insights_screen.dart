import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.go('/pantry'); // Go back to pantry tab
                    },
                    icon: const Icon(Icons.arrow_back, color: AppColors.soil),
                  ),
                  const Text(
                    'Waste Tracker',
                    style: TextStyle(
                      fontFamily: 'DM Serif Display',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer to balance back button
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top 2 Cards
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F4EB), // Light cream
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('WASTE SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate, letterSpacing: 0.5)),
                                const SizedBox(height: 8),
                                const Text('33%', style: TextStyle(fontFamily: 'DM Serif Display', fontSize: 32, color: AppColors.forest)),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.forest.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Excellent', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.forest)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F4EB), // Light cream
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('EST. LOSS SAVED', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.slate, letterSpacing: 0.5)),
                                SizedBox(height: 8),
                                Text('₱450.00', style: TextStyle(fontFamily: 'DM Serif Display', fontSize: 26, color: AppColors.forest)),
                                SizedBox(height: 8),
                                Text('Saved this month', style: TextStyle(fontSize: 11, color: AppColors.slate)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Discarded Food Categories
                    Row(
                      children: [
                        const Icon(Icons.pie_chart_outline, color: AppColors.slate, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'DISCARDED FOOD CATEGORIES',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.slate.withValues(alpha: 0.8), letterSpacing: 0.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCategoryRow('Leafy Greens', '50% of waste', 0.5, AppColors.today),
                    const SizedBox(height: 12),
                    _buildCategoryRow('Vegetables', '35% of waste', 0.35, AppColors.clay),
                    const SizedBox(height: 12),
                    _buildCategoryRow('Proteins', '50% of waste', 0.15, AppColors.safe), // scaled small visually
                    const SizedBox(height: 32),

                    // Smart Advice
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF6F0),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline, color: AppColors.forest, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'SMART ADVICE FOR YOU',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.forest.withValues(alpha: 0.8), letterSpacing: 0.5),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: AppColors.slate, fontSize: 13, height: 1.5),
                              children: [
                                TextSpan(text: '"You consistently throw away '),
                                TextSpan(text: 'Kangkong', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.today)),
                                TextSpan(text: ' after 2 days. Consider buying the half-bundle from Aling Nena\'s wet-market instead of SM supermarkets to minimize financial loss."'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // History
                    Text(
                      'DISCARD & CONSUMPTION HISTORY',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.slate.withValues(alpha: 0.8), letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 16),
                    _buildHistoryItem('Calamansi (10pcs)', '3 days ago • Loss: ₱35', 'Spoiled'),
                    const SizedBox(height: 12),
                    _buildHistoryItem('Kangkong bundle', 'Last week • Loss: ₱25', 'Spoiled'),
                    const SizedBox(height: 32),

                    // Back to Pantry Action
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/pantry');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.forest,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Back to Pantry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(String name, String label, double fraction, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.soil)),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.stone.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  height: 6,
                  width: constraints.maxWidth * fraction,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildHistoryItem(String title, String subtitle, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF6F0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE9E9), // Light pink/red
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete_outline, color: AppColors.today, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.soil)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.slate)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFDE9E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(status, style: const TextStyle(color: AppColors.today, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
