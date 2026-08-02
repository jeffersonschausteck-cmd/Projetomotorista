import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

class VehiclesListScreen extends StatelessWidget {
  const VehiclesListScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComingSoonScreen(title: 'Veículos', phase: 'Fase 1/2');
}
