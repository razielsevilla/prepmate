import 'package:flutter/material.dart';
export 'pantry/pantry_screen.dart';
export 'add_item/add_item_screen.dart';
export 'planner/prep_planner_screen.dart';
export 'batches/batches_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Onboarding')));
}







class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Insights')));
}
