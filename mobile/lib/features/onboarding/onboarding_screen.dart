import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedType = 'house'; // 'student' or 'house'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.mist,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.eco, color: AppColors.forest, size: 32),
                  ),
                  const SizedBox(height: 24),
                  const Text('Prep Smart.', style: TextStyle(fontFamily: 'DM Serif Display', fontSize: 36, color: AppColors.forest)),
                  const Text('Waste Less.', style: TextStyle(fontFamily: 'DM Serif Display', fontSize: 36, color: AppColors.forest)),
                  const SizedBox(height: 16),
                  const Text(
                    'The intelligent, offline-first pantry guide tailored for local households.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.slate, fontSize: 14),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('How do you manage food?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.soil, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedType = 'student'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedType == 'student' ? AppColors.forest : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Single / Student',
                                style: TextStyle(
                                  color: selectedType == 'student' ? AppColors.forest : AppColors.slate,
                                  fontWeight: selectedType == 'student' ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedType = 'house'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: selectedType == 'house' ? AppColors.forest : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Household',
                                style: TextStyle(
                                  color: selectedType == 'house' ? AppColors.forest : AppColors.slate,
                                  fontWeight: selectedType == 'house' ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selectedType == 'student'
                        ? 'Shorter preservation window alerts. Setup perfect for single dorm fridges.'
                        : 'Shared family tracking enabled. Includes local Wet-Market seasonal prediction buffers.',
                    style: const TextStyle(color: AppColors.slate, fontSize: 12),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to pantry
                        context.go('/pantry');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Welcome to PrepMate!'),
                            backgroundColor: AppColors.forest,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.forest,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Start Prepping', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
