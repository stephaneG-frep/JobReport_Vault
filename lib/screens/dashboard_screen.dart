import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/statistics_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/statistics_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = context.watch<StatisticsProvider>().statistics;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(title: const Text('JobReport Vault')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final count = width > 1200
                  ? 4
                  : width > 720
                  ? 3
                  : 1;
              return GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: count,
                  childAspectRatio: count == 1 ? 3.5 : 2.2,
                ),
                children: [
                  DashboardCard(
                    title: 'Rapports',
                    value: '${stats.totalReports}',
                    icon: Icons.article,
                  ),
                  DashboardCard(
                    title: 'Ce mois',
                    value: '${stats.monthReports}',
                    icon: Icons.calendar_month,
                    color: Colors.green,
                  ),
                  DashboardCard(
                    title: 'Cette semaine',
                    value: '${stats.weekReports}',
                    icon: Icons.view_week,
                    color: Colors.orange,
                  ),
                  DashboardCard(
                    title: 'Dernière activité',
                    value: stats.lastActivity == null
                        ? 'Aucune'
                        : dateFormat.format(stats.lastActivity!),
                    icon: Icons.history,
                  ),
                  DashboardCard(
                    title: 'Dernier export',
                    value: stats.lastExport == null
                        ? 'Jamais'
                        : dateFormat.format(stats.lastExport!),
                    icon: Icons.ios_share,
                  ),
                  DashboardCard(
                    title: 'Preuves',
                    value: '${stats.proofCount}',
                    icon: Icons.verified,
                  ),
                  DashboardCard(
                    title: 'Candidatures',
                    value: '${stats.applicationCount}',
                    icon: Icons.send,
                  ),
                  DashboardCard(
                    title: 'Relances',
                    value: '${stats.followUpCount}',
                    icon: Icons.refresh,
                  ),
                  DashboardCard(
                    title: 'Entretiens',
                    value: '${stats.interviewCount}',
                    icon: Icons.forum,
                  ),
                  DashboardCard(
                    title: 'Temps total',
                    value: stats.totalTimeLabel,
                    icon: Icons.timer,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final twoColumns = constraints.maxWidth > 900;
              final children = [
                StatisticsCard(
                  title: 'Rapports par type',
                  values: stats.reportsByType,
                  chartType: ChartType.bars,
                ),
                StatisticsCard(
                  title: 'Répartition',
                  values: {
                    'Candidatures': stats.applicationCount,
                    'Relances': stats.followUpCount,
                    'Entretiens': stats.interviewCount,
                    'Preuves': stats.proofCount,
                  },
                  chartType: ChartType.pie,
                ),
                StatisticsCard(
                  title: 'Activités récentes',
                  values: {
                    for (final entry in stats.activitiesByDay.entries.take(12))
                      DateFormat('dd/MM').format(entry.key): entry.value,
                  },
                  chartType: ChartType.line,
                ),
                _MiniCalendar(values: stats.activitiesByDay),
              ];
              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: twoColumns ? 2 : 1,
                childAspectRatio: twoColumns ? 1.9 : 1.3,
                children: children,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MiniCalendar extends StatelessWidget {
  const _MiniCalendar({required this.values});

  final Map<DateTime, int> values;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month);
    final days = DateUtils.getDaysInMonth(now.year, now.month);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calendrier miniature',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (var i = 0; i < firstDay.weekday - 1; i++)
                    const SizedBox(),
                  for (var day = 1; day <= days; day++)
                    _DayCell(
                      day: day,
                      count: values[DateTime(now.year, now.month, day)] ?? 0,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.day, required this.count});

  final int day;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = count > 0
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surfaceContainerHighest;
    return Container(
      margin: const EdgeInsets.all(2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: count > 0 ? 0.22 : 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text('$day'),
    );
  }
}
