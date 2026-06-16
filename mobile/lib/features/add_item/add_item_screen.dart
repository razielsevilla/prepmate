import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  int _activeTab = 0; // 0: Manual, 1: Receipt, 2: Barcode

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'Add Food Item',
                    style: TextStyle(
                      fontFamily: 'DM Serif Display',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forest,
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer to balance back button
                ],
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.stone.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTab('Manual / Quick', 0),
                    _buildTab('Receipt (AI)', 1),
                    _buildTab('Barcode', 2),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Content
            Expanded(
              child: _buildContent(),
            ),

            // Bottom Cancel Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/pantry');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.slate, // Dark grey
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? AppColors.forest : AppColors.slate.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (_activeTab) {
      case 0:
        return _buildManualTab();
      case 1:
        return _buildOCRTab();
      case 2:
        return _buildBarcodeTab();
      default:
        return const SizedBox();
    }
  }

  // ================= MANUAL TAB =================
  Widget _buildManualTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const Text(
          'POPULAR WET MARKET PRESETS',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.slate, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        // Presets Grid
        Row(
          children: [
            Expanded(child: _buildPresetPill('🥬', 'Kangkong', '2 days', AppColors.today)),
            const SizedBox(width: 12),
            Expanded(child: _buildPresetPill('🍗', 'Chicken', '14 days', AppColors.safe)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildPresetPill('🐟', 'Bangus', '3 days', AppColors.clay)), // using clay/orange for soon
            const SizedBox(width: 12),
            Expanded(child: _buildPresetPill('🌱', 'Sitaw', '6 days', AppColors.safe)),
          ],
        ),
        const SizedBox(height: 24),

        // Custom Entry Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6F0), // slightly lighter warm cream
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CUSTOM ENTRY',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.slate, letterSpacing: 0.5),
              ),
              const SizedBox(height: 16),
              
              const Text('Item Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.soil)),
              const SizedBox(height: 8),
              _buildInputField('e.g. Pork Liempo'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Storage Zone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.soil)),
                        const SizedBox(height: 8),
                        Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.cream,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: 'Refrigerator',
                              icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                              style: const TextStyle(fontSize: 13, color: AppColors.soil),
                              onChanged: (String? newValue) {},
                              items: <String>['Refrigerator', 'Freezer', 'Dry Pantry']
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.soil)),
                        const SizedBox(height: 8),
                        _buildInputField('e.g. 500g, 1 pack'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Action
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('+ Add to Pantry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forest,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPresetPill(String emoji, String name, String days, Color daysColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.soil)),
            ],
          ),
          Text(days, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: daysColor)),
        ],
      ),
    );
  }

  Widget _buildInputField(String hint) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.slate),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        style: const TextStyle(fontSize: 13, color: AppColors.soil),
      ),
    );
  }

  // ================= RECEIPT TAB =================
  Widget _buildOCRTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF5ED), // Light orange/peach tint
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.hub_outlined, color: AppColors.forest, size: 16),
                  SizedBox(width: 8),
                  Text('Deterministic Normalizer', style: TextStyle(color: AppColors.forest, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Standardizes raw cash-register outputs using string distance matches. Select a template or paste custom raw text below to test it.',
                style: TextStyle(color: AppColors.soil.withValues(alpha: 0.8), fontSize: 13, height: 1.4),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.stone.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Puregold Run', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.soil)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.stone.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Wet-Market Note', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.soil)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Raw Receipt Feed',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.soil),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: const Color(0xFF2B2521), // dark brown/black
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.center_focus_strong, size: 20),
            label: const Text('Parse & Standardize', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.forest,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // ================= BARCODE TAB =================
  Widget _buildBarcodeTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: const Color(0xFF2B2521), // dark brown/black
            borderRadius: BorderRadius.circular(24),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Reticle corners (simplified)
              Positioned(top: 20, left: 20, child: _buildCorner(0)),
              Positioned(top: 20, right: 20, child: _buildCorner(1)),
              Positioned(bottom: 20, right: 20, child: _buildCorner(2)),
              Positioned(bottom: 20, left: 20, child: _buildCorner(3)),
              
              // Camera center
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, color: AppColors.stone.withValues(alpha: 0.5), size: 32),
                  const SizedBox(height: 12),
                  Text('Simulating On-Device Camera View', style: TextStyle(color: AppColors.stone.withValues(alpha: 0.5), fontSize: 12)),
                ],
              ),
              
              // Laser line
              Container(
                width: double.infinity,
                height: 2,
                color: AppColors.today.withValues(alpha: 0.8), // Red laser
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Point your device camera at a packaged UPC code to scan instant expiry data.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.slate, fontSize: 13, height: 1.4),
        ),
        const SizedBox(height: 32),
        const Text(
          'SIMULATE SCAN MATCH',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.slate, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.stone.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              const Icon(Icons.qr_code, color: AppColors.slate, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Lucky Me Instant Noodles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.soil)),
                    const SizedBox(height: 4),
                    Text('UPC: 4800016024921', style: TextStyle(fontSize: 12, color: AppColors.slate.withValues(alpha: 0.8))),
                  ],
                ),
              ),
              const Text(
                'Safe (120d)',
                style: TextStyle(color: AppColors.safe, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorner(int rotations) {
    return RotatedBox(
      quarterTurns: rotations,
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.stone, width: 2),
            left: BorderSide(color: AppColors.stone, width: 2),
          ),
        ),
      ),
    );
  }
}
