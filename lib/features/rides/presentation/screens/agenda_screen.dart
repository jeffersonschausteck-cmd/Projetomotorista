import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

class AgendaScreen extends StatelessWidget {
  const AgendaScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComingSoonScreen(title: 'Agenda', phase: 'Fase 1');
}
