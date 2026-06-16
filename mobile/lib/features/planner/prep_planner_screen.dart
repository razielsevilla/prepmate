import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class PrepPlannerScreen extends ConsumerWidget {
  const PrepPlannerScreen({super.key});

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
                    'Smart Prep Plan',
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
                    // Expiry Rescue Mission Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F3E8), // Very light green tint
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EXPIRY RESCUE MISSION',
                                style: TextStyle(
                                  color: AppColors.forest.withValues(alpha: 0.8),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                '2 items rescued from waste',
                                style: TextStyle(
                                  color: AppColors.forest,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.forest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.workspace_premium, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Subtitle
                    const Text(
                      'ESTIMATED SESSION: 35 MINUTES',
                      style: TextStyle(
                        color: AppColors.slate,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Main Prep Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDF7F0), // Very warm cream
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppColors.clay.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB45330), // Dark rust orange
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'Batch 1: Rescue Sauté',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Text('Rescuing 2 items', style: TextStyle(color: AppColors.slate, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Stir-Fried Kangkong Mix',
                            style: TextStyle(
                              fontFamily: 'DM Serif Display',
                              color: AppColors.forest,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(color: AppColors.soil, fontSize: 13, height: 1.5),
                              children: [
                                TextSpan(text: 'Cook your expiring '),
                                TextSpan(text: 'Kangkong', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                                TextSpan(text: ' and '),
                                TextSpan(text: 'Chicken breast', style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                                TextSpan(text: ' together immediately. The high sodium base preserves shelf-life of cooked foods up to 4 additional days.'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Prep Instructions:',
                            style: TextStyle(color: AppColors.forest, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '1. Prepare Kangkong first.\n2. Toss remaining ingredients with garlic and soy sauce.',
                            style: TextStyle(color: AppColors.slate, fontSize: 12, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Storage Map
                    Row(
                      children: [
                        const Icon(Icons.ac_unit, color: AppColors.forest, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'SMART CONTAINER STORAGE MAP',
                          style: TextStyle(
                            color: AppColors.slate.withValues(alpha: 0.8),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F7F2), // Light cream
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Meal 1-2', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.soil, fontSize: 14)),
                                SizedBox(height: 2),
                                Text('Keep Refrigerated', style: TextStyle(color: AppColors.slate, fontSize: 11)),
                                SizedBox(height: 6),
                                Text('Eat by Thursday', style: TextStyle(color: AppColors.today, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F7F2), // Light cream
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Meal 3-4', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.soil, fontSize: 14)),
                                SizedBox(height: 2),
                                Text('Freeze Airtight', style: TextStyle(color: AppColors.slate, fontSize: 11)),
                                SizedBox(height: 6),
                                Text('Safe for 14d', style: TextStyle(color: AppColors.safe, fontWeight: FontWeight.bold, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Actions
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.push('/shopping');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.forest,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Review Missing Shopping Gap List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          // Mark as prepped action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.forest,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, size: 18),
                            SizedBox(width: 8),
                            Text('Mark session as Prepped', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'This automatically consumes ingredients used in your database.',
                        style: TextStyle(color: AppColors.slate, fontSize: 10),
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
}
