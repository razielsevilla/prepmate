import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  int? activeUrgencyFilter; // null, 1 (today), 4 (soon)

  @override
  Widget build(BuildContext context) {
    final pantryItems = ref.watch(pantryProvider);

    // Filter logic
    final filteredItems = pantryItems.where((item) {
      final matchesSearch = item.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesZone = selectedZone == 'All' || item.zone == selectedZone;
      final matchesUrgency = activeUrgencyFilter == null || item.expiryDays <= activeUrgencyFilter!;
      return matchesSearch && matchesZone && matchesUrgency;
    }).toList()
      ..sort((a, b) => a.expiryDays.compareTo(b.expiryDays));

    // Stats logic
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
      appBar: AppBar(
        title: const Text('Pantry'),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.forest.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalItems items',
                style: const TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // Search and Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.stone),
                    ),
                    child: TextField(
                      onChanged: (val) => setState(() => searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: 'Search ingredients...',
                        prefixIcon: Icon(Icons.search, size: 20, color: AppColors.slate),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.stone),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedZone,
                      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                      style: const TextStyle(fontSize: 14, color: AppColors.soil),
                      onChanged: (String? newValue) {
                        if (newValue != null) setState(() => selectedZone = newValue);
                      },
                      items: <String>['All', 'Fridge', 'Freezer', 'Dry Pantry']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Urgency Matrix
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.stone.withOpacity(0.5)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$countToday item${countToday != 1 ? 's' : ''} need rescue',
                        style: const TextStyle(color: AppColors.today, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatColumn('Today', countToday.toString(), AppColors.today),
                      _buildStatColumn('This Week', countSoon.toString(), AppColors.soon),
                      _buildStatColumn('Safe', countSafe.toString(), AppColors.safe),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: SizedBox(
                      height: 8,
                      child: Row(
                        children: [
                          Expanded(flex: (todayPct * 100).toInt(), child: Container(color: AppColors.today)),
                          Expanded(flex: (soonPct * 100).toInt(), child: Container(color: AppColors.soon)),
                          Expanded(flex: (safePct * 100).toInt(), child: Container(color: AppColors.safe)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Urgency Ribbon Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('Use Today', 1, AppColors.today),
                const SizedBox(width: 8),
                _buildFilterChip('This Week', 4, AppColors.soon),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(child: Text('No matching food found.', style: TextStyle(color: AppColors.slate)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _buildPantryCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String count, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(count, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'DM Serif Display')),
        Text(label, style: const TextStyle(color: AppColors.slate, fontSize: 10, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildFilterChip(String label, int daysFilter, Color activeColor) {
    final isActive = activeUrgencyFilter == daysFilter;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeUrgencyFilter = isActive ? null : daysFilter;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? activeColor : AppColors.stone),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : AppColors.slate,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPantryCard(PantryItem item) {
    Color bg, text, border;
    String label;
    if (item.expiryDays <= 1) {
      bg = AppColors.today.withOpacity(0.1);
      text = AppColors.today;
      border = AppColors.today;
      label = 'Use today';
    } else if (item.expiryDays <= 4) {
      bg = AppColors.soon.withOpacity(0.1);
      text = AppColors.soon;
      border = AppColors.soon;
      label = 'This week';
    } else {
      bg = AppColors.safe.withOpacity(0.1);
      text = AppColors.safe;
      border = AppColors.safe;
      label = 'Safe';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stone.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.eco, color: AppColors.forest), // simplified icon logic
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(item.category, style: const TextStyle(fontSize: 11, color: AppColors.slate)),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(fontSize: 11, color: AppColors.stone)),
                      const SizedBox(width: 8),
                      Text(item.zone, style: const TextStyle(fontSize: 11, color: AppColors.slate)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bg,
                border: Border.all(color: border.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: TextStyle(color: text, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
