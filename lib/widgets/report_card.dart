import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/job_report.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report, required this.onTap});

  final JobReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          child: Text(report.title.characters.first.toUpperCase()),
        ),
        title: Text(report.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          '${report.type.label} • ${DateFormat('dd/MM/yyyy HH:mm').format(report.date)}\n'
          '${report.company.name.isEmpty ? 'Sans entreprise' : report.company.name} • ${report.result}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Chip(
              label: Text(report.status.label),
              visualDensity: VisualDensity.compact,
            ),
            Icon(
              _priorityIcon(report.priority),
              color: _priorityColor(report.priority),
            ),
          ],
        ),
      ),
    );
  }

  IconData _priorityIcon(ReportPriority priority) => switch (priority) {
    ReportPriority.low => Icons.keyboard_arrow_down,
    ReportPriority.normal => Icons.remove,
    ReportPriority.high => Icons.priority_high,
    ReportPriority.urgent => Icons.warning_amber,
  };

  Color _priorityColor(ReportPriority priority) => switch (priority) {
    ReportPriority.low => Colors.green,
    ReportPriority.normal => Colors.blueGrey,
    ReportPriority.high => Colors.orange,
    ReportPriority.urgent => Colors.red,
  };
}
