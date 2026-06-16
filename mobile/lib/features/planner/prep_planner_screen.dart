import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/state/providers.dart';

class PrepPlannerScreen extends ConsumerStatefulWidget {
  const PrepPlannerScreen({super.key});

  @override
  ConsumerState<PrepPlannerScreen> createState() => _PrepPlannerScreenState();
}

class _PrepPlannerScreenState extends ConsumerState<PrepPlannerScreen> {
  int prepDays = 5;
  bool isGenerated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Prep Plan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target Prep Days',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: prepDays.toDouble(),
                    min: 1,
                    max: 7,
                    divisions: 6,
                    activeColor: AppColors.forest,
                    inactiveColor: AppColors.stone,
                    label: prepDays.toString(),
                    onChanged: (val) => setState(() => prepDays = val.toInt()),
                  ),
                ),
                Text(
                  '$prepDays Days',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.forest),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  setState(() => isGenerated = true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.forest,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Generate Weekly Plan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            if (isGenerated) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.mist,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.forest.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: AppColors.forest),
                        SizedBox(width: 8),
                        Text('Prep Schedule Generated!',
                            style: TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Rescued 2 at-risk items (Kangkong, Pork Liempo)',
                        style: TextStyle(color: AppColors.forest, fontSize: 12)),
                    const SizedBox(height: 16),
                    _buildDayBlock('Day 1-2', 'Pork Sinigang', 'Fridge: Eat within 3 days'),
                    const SizedBox(height: 12),
                    _buildDayBlock('Day 3-5', 'Chicken Adobo', 'Freezer: Transfer to fridge night before'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.forest,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.forest),
                          ),
                        ),
                        child: const Text('Commit & Add to Batches', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/shopping');
                        },
                        icon: const Icon(Icons.arrow_right_alt),
                        label: const Text('Review Missing Shopping Gap List', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.forest,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDayBlock(String days, String meal, String note) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.stone.withOpacity(0.3), borderRadius: BorderRadius.circular(8)),
            child: Text(days, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meal, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(note, style: const TextStyle(fontSize: 10, color: AppColors.slate)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
