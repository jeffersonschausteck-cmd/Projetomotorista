import 'package:flutter/material.dart';

import '../../domain/entities/maintenance_reminder.dart';

class MaintenanceAlertBanner extends StatelessWidget {
  const MaintenanceAlertBanner({
    required this.reminders,
    required this.currentKm,
    super.key,
  });

  final List<MaintenanceReminder> reminders;
  final double? currentKm;

  static const _labels = {
    MaintenanceType.oilChange: 'Troca de óleo',
    MaintenanceType.revision: 'Revisão',
    MaintenanceType.tires: 'Pneus',
    MaintenanceType.insurance: 'Seguro',
    MaintenanceType.ipva: 'IPVA',
    MaintenanceType.documentation: 'Documentação',
    MaintenanceType.other: 'Outro',
  };

  @override
  Widget build(BuildContext context) {
    final overdue = <MaintenanceReminder>[];
    final upcoming = <MaintenanceReminder>[];
    for (final reminder in reminders) {
      final status = reminder.statusFor(currentKm: currentKm);
      if (status == ReminderStatus.overdue) {
        overdue.add(reminder);
      } else if (status == ReminderStatus.upcoming) {
        upcoming.add(reminder);
      }
    }

    if (overdue.isEmpty && upcoming.isEmpty) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final isOverdue = overdue.isNotEmpty;
    final color = isOverdue ? scheme.error : Colors.orange;
    final items = isOverdue ? overdue : upcoming;
    final label = items.map((r) => _labels[r.type]).join(', ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(isOverdue ? Icons.error_outline : Icons.warning_amber_outlined, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isOverdue ? 'Vencido: $label' : 'Vencendo em breve: $label',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
