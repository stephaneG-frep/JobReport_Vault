import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/statistics_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/statistics_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatisticsProvider>().statistics;
    return Scaffold(
      appBar: AppBar(title: const Text('Statistiques')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            children: [
              SizedBox(
                width: 260,
                child: DashboardCard(
                  title: 'Entreprises contactées',
                  value: '${stats.companiesContacted}',
                  icon: Icons.business,
                ),
              ),
              SizedBox(
                width: 260,
                child: DashboardCard(
                  title: 'Plateformes utilisées',
                  value: '${stats.platformsUsed}',
                  icon: Icons.public,
                ),
              ),
              SizedBox(
                width: 260,
                child: DashboardCard(
                  title: 'Documents archivés',
                  value: '${stats.documentsArchived}',
                  icon: Icons.folder,
                ),
              ),
              SizedBox(
                width: 260,
                child: DashboardCard(
                  title: 'Temps passé',
                  value: stats.totalTimeLabel,
                  icon: Icons.timer,
                ),
              ),
            ],
          ),
          StatisticsCard(
            title: 'Graphique en barres',
            values: stats.reportsByType,
            chartType: ChartType.bars,
          ),
          StatisticsCard(
            title: 'Courbe des activités',
            values: {
              for (final entry in stats.activitiesByDay.entries.take(16))
                '${entry.key.day}/${entry.key.month}': entry.value,
            },
            chartType: ChartType.line,
          ),
          StatisticsCard(
            title: 'Camembert des actions',
            values: {
              'Candidatures': stats.applicationCount,
              'Relances': stats.followUpCount,
              'Entretiens': stats.interviewCount,
              'Documents': stats.documentsArchived,
            },
            chartType: ChartType.pie,
          ),
          StatisticsCard(
            title: 'Histogramme',
            values: stats.reportsByType,
            chartType: ChartType.histogram,
          ),
        ],
      ),
    );
  }
}
