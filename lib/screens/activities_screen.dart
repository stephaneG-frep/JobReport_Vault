import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/activity_provider.dart';
import '../widgets/activity_card.dart';

class ActivitiesScreen extends StatelessWidget {
  const ActivitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = context.watch<ActivityProvider>().activities;
    return Scaffold(
      appBar: AppBar(title: const Text('Activités')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: activities.isEmpty
            ? [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Aucune activité enregistrée.'),
                  ),
                ),
              ]
            : activities
                  .map((activity) => ActivityCard(activity: activity))
                  .toList(),
      ),
    );
  }
}
