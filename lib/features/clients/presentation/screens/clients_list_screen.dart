import 'package:flutter/material.dart';

import '../../../../core/widgets/coming_soon_screen.dart';

class ClientsListScreen extends StatelessWidget {
  const ClientsListScreen({super.key});

  @override
  Widget build(BuildContext context) =>
      const ComingSoonScreen(title: 'Clientes', phase: 'Fase 1');
}
