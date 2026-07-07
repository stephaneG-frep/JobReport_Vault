import 'package:flutter/material.dart';

import '../models/job_report.dart';

class FilterPanel extends StatelessWidget {
  const FilterPanel({
    super.key,
    required this.type,
    required this.status,
    required this.priority,
    required this.onChanged,
    required this.onClear,
  });

  final ReportType? type;
  final ReportStatus? status;
  final ReportPriority? priority;
  final void Function(ReportType?, ReportStatus?, ReportPriority?) onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _dropdown<ReportType>(
          label: 'Type',
          value: type,
          values: ReportType.values,
          text: (item) => item.label,
          onChanged: (value) => onChanged(value, status, priority),
        ),
        _dropdown<ReportStatus>(
          label: 'Statut',
          value: status,
          values: ReportStatus.values,
          text: (item) => item.label,
          onChanged: (value) => onChanged(type, value, priority),
        ),
        _dropdown<ReportPriority>(
          label: 'Priorité',
          value: priority,
          values: ReportPriority.values,
          text: (item) => item.label,
          onChanged: (value) => onChanged(type, status, value),
        ),
        OutlinedButton.icon(
          onPressed: onClear,
          icon: const Icon(Icons.filter_alt_off),
          label: const Text('Effacer'),
        ),
      ],
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<T> values,
    required String Function(T) text,
    required ValueChanged<T?> onChanged,
  }) {
    return SizedBox(
      width: 220,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: values
            .map(
              (item) => DropdownMenuItem(value: item, child: Text(text(item))),
            )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
