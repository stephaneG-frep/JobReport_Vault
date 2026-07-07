import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/job_report.dart';
import '../providers/report_provider.dart';
import '../widgets/filter_panel.dart';
import '../widgets/report_card.dart';
import '../widgets/search_bar.dart';
import 'report_detail_screen.dart';
import 'report_form_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReportProvider>();
    final reports = provider.filteredReports;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rapports'),
        actions: [
          IconButton(
            tooltip: 'Nouveau rapport',
            onPressed: () => _openForm(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Créer'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          VaultSearchBar(value: provider.query, onChanged: provider.setQuery),
          const SizedBox(height: 12),
          FilterPanel(
            type: provider.typeFilter,
            status: provider.statusFilter,
            priority: provider.priorityFilter,
            onChanged: (type, status, priority) => provider.setFilters(
              type: type,
              status: status,
              priority: priority,
            ),
            onClear: () => provider.setFilters(clear: true),
          ),
          const SizedBox(height: 12),
          if (reports.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Aucun rapport ne correspond aux critères.'),
              ),
            )
          else
            ...reports.map(
              (report) => ReportCard(
                report: report,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReportDetailScreen(reportId: report.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, [JobReport? report]) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => ReportFormScreen(report: report)));
  }
}
