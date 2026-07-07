import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/job_report.dart';

class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.report, required this.onTap});

  final JobReport report;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(child: Text(_initial)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${report.type.label} • ${DateFormat('dd/MM/yyyy HH:mm').format(report.date)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _priorityIcon(report.priority),
                    color: _priorityColor(report.priority),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${report.company.name.isEmpty ? 'Sans entreprise' : report.company.name} • ${report.result.isEmpty ? 'Sans résultat' : report.result}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(
                    label: Text(report.status.label),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    avatar: Icon(
                      _priorityIcon(report.priority),
                      size: 16,
                      color: _priorityColor(report.priority),
                    ),
                    label: Text(report.priority.label),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (report.tags.isNotEmpty)
                    Chip(
                      label: Text(report.tags.first),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _initial {
    final trimmed = report.title.trim();
    return trimmed.isEmpty ? '?' : trimmed.characters.first.toUpperCase();
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
