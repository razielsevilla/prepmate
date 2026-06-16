import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/models/models.dart';
import '../../core/state/providers.dart';
import '../../core/theme/app_colors.dart';

class PantryScreen extends ConsumerStatefulWidget {
  const PantryScreen({super.key});

  @override
  ConsumerState<PantryScreen> createState() => _PantryScreenState();
}

class _PantryScreenState extends ConsumerState<PantryScreen> {
  String searchQuery = '';
  String selectedZone = 'All';
  int? activeUrgencyFilter;

  @override
  Widget build(BuildContext context) {
    final pantryItems = ref.watch(pantryProvider);

    final filteredItems = pantryItems.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesZone = selectedZone == 'All' || item.zone == selectedZone;
      final matchesUrgency = activeUrgencyFilter == null || item.expiryDays <= activeUrgencyFilter!;
      return matchesSearch && matchesZone && matchesUrgency;
    }).toList()
      ..sort((a, b) => a.expiryDays.compareTo(b.expiryDays));

    int countToday = 0;
    int countSoon = 0;
    int countSafe = 0;

    for (var item in pantryItems) {
      if (item.expiryDays <= 1) {
        countToday++;
      } else if (item.expiryDays <= 4) {
        countSoon++;
      } else {
        countSafe++;
      }
    }

    final totalItems = pantryItems.length;
    final todayPct = totalItems > 0 ? countToday / totalItems : 0.0;
    final soonPct = totalItems > 0 ? countSoon / totalItems : 0.0;
    final safePct = totalItems > 0 ? countSafe / totalItems : 0.0;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 12),
              color: AppColors.cream.withValues(alpha: 0.9),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'My Pantry',
                            style: TextStyle(
                              fontFamily: 'DM Serif Display',
                              fontSize: 28,
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
                              '$totalItems items',
                              style: const TextStyle(
                                color: AppColors.forest,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          context.push('/insights');
                        },
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.bar_chart, color: AppColors.slate, size: 28),
                            Positioned(
                              top: -2,
                              right: -4,
                              child: Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD38B7C), // match the salmon pink dot
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.cream, width: 1.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Urgent Warnings Ribbon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        activeUrgencyFilter = activeUrgencyFilter == 1 ? null : 1;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2), // red-50
                        border: Border.all(color: const Color(0xFFFECACA), width: 1), // red-200
                        borderRadius: BorderRadius.circular(24), // very rounded
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'USE TODAY',
                            style: TextStyle(
                              color: AppColors.today,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '$countToday item${countToday != 1 ? 's' : ''} needs rescue',
                            style: const TextStyle(
                              color: AppColors.today,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dynamic Urgent Matrix Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 6,
                      child: Row(
                        children: [
                          Expanded(flex: (todayPct * 100).toInt(), child: Container(color: AppColors.today)),
                          Expanded(flex: (soonPct * 100).toInt(), child: Container(color: AppColors.clay)),
                          Expanded(flex: (safePct * 100).toInt(), child: Container(color: AppColors.safe)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search and Filter Pills
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.stone.withValues(alpha: 0.3), // Light grey
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            onChanged: (val) => setState(() => searchQuery = val),
                            decoration: const InputDecoration(
                              hintText: 'Search ingredients...',
                              hintStyle: TextStyle(color: AppColors.slate, fontSize: 14),
                              prefixIcon: Icon(Icons.search, size: 18, color: AppColors.slate),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            style: const TextStyle(fontSize: 14, color: AppColors.soil),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.stone.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedZone,
                            icon: const Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.soil),
                            style: const TextStyle(fontSize: 14, color: AppColors.soil, fontWeight: FontWeight.bold),
                            onChanged: (String? newValue) {
                              if (newValue != null) setState(() => selectedZone = newValue);
                            },
                            items: <String>['All', 'Fridge', 'Freezer', 'Dry Pantry']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value == 'All' ? 'All Storage' : (value == 'Fridge' ? 'Ref' : value)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable Pantry List
            Expanded(
              child: filteredItems.isEmpty
                  ? const Center(child: Text('No matching food found.', style: TextStyle(color: AppColors.slate)))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildPantryCard(item, ref);
                      },
                    ),
            ),

            // Bottom Action Deck
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 12),
              color: AppColors.cream.withValues(alpha: 0.9),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/planner');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forest,
                        foregroundColor: AppColors.cream,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Generate prep plan',
                            style: TextStyle(fontFamily: 'DM Serif Display', fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.auto_awesome, color: AppColors.turmeric, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLegend(AppColors.safe, 'Safe'),
                      _buildLegend(AppColors.clay, 'Soon'), // In prototype, "Soon" is orange/clay
                      _buildLegend(AppColors.today, 'Today'),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13, color: AppColors.slate, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildPantryCard(PantryItem item, WidgetRef ref) {
    Color dotColor;
    if (item.expiryDays <= 1) {
      dotColor = AppColors.today;
    } else if (item.expiryDays <= 4) {
      dotColor = AppColors.clay;
    } else {
      dotColor = AppColors.safe;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F2EB), // slightly darker cream for the card
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.stone.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.soil)),
                  const SizedBox(height: 4),
                  Text(
                    '${item.category} • 1 pack • ${item.zone}', // Hardcoded "1 pack" matching the prototype mockup style, ideally from model
                    style: const TextStyle(fontSize: 12, color: AppColors.slate),
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
                '${item.expiryDays}d left',
                style: const TextStyle(color: AppColors.slate, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                ref.read(pantryProvider.notifier).consume(item.id);
              },
              child: const Icon(Icons.check, color: AppColors.safe, size: 22),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                ref.read(pantryProvider.notifier).discard(item.id);
              },
              child: const Icon(Icons.delete_outline, color: AppColors.today, size: 22),
            ),
          ],
        ),
      ),
    );
  }
}
