import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.task_alt),
        title: Text(activity.type.label),
        subtitle: Text(
          '${DateFormat('dd/MM/yyyy HH:mm').format(activity.date)} • ${activity.durationMinutes} min\n'
          '${activity.description}${activity.company.isEmpty ? '' : '\n${activity.company}'}',
        ),
        isThreeLine: true,
        trailing: Text(activity.result, textAlign: TextAlign.end),
      ),
    );
  }
}
