import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../models/job_report.dart';
import '../models/proof.dart';
import '../providers/report_provider.dart';
import '../services/storage_service.dart';
import '../widgets/activity_card.dart';
import '../widgets/attachment_tile.dart';
import '../widgets/proof_tile.dart';
import 'report_form_screen.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    final report = context.watch<ReportProvider>().reports.firstWhere(
      (item) => item.id == reportId,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(report.title),
        actions: [
          IconButton(
            tooltip: 'Modifier',
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReportFormScreen(report: report),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Supprimer',
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              await context.read<ReportProvider>().moveToTrash(report.id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            report.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(report.type.label)),
              Chip(label: Text(report.status.label)),
              Chip(label: Text(report.priority.label)),
              if (report.company.name.isNotEmpty)
                Chip(label: Text(report.company.name)),
            ],
          ),
          const Divider(height: 32),
          _section('Activités', Icons.task_alt, [
            ...report.activities.map(
              (activity) => ActivityCard(activity: activity),
            ),
            OutlinedButton.icon(
              onPressed: () => _addActivity(context),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter une activité'),
            ),
          ]),
          _section('Documents', Icons.folder, [
            ...report.attachments.map(
              (attachment) => AttachmentTile(attachment: attachment),
            ),
            OutlinedButton.icon(
              onPressed: () => _addAttachment(context),
              icon: const Icon(Icons.attach_file),
              label: const Text('Joindre un document'),
            ),
          ]),
          _section('Preuves', Icons.verified, [
            ...report.proofs.map((proof) => ProofTile(proof: proof)),
            OutlinedButton.icon(
              onPressed: () => _addProof(context),
              icon: const Icon(Icons.add_moderator),
              label: const Text('Ajouter une preuve'),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [Icon(icon), const SizedBox(width: 8), Text(title)]),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _addActivity(BuildContext context) async {
    final controller = TextEditingController();
    final saved = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle activité'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Description'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (saved == null || saved.trim().isEmpty || !context.mounted) return;
    await context.read<ReportProvider>().addActivity(
      reportId,
      Activity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: ActivityType.other,
        date: DateTime.now(),
        durationMinutes: 30,
        description: saved.trim(),
        result: 'Ajouté',
      ),
    );
  }

  Future<void> _addAttachment(BuildContext context) async {
    final attachment = await context
        .read<StorageService>()
        .pickAndCopyAttachment();
    if (attachment != null && context.mounted) {
      await context.read<ReportProvider>().addAttachment(reportId, attachment);
    }
  }

  Future<void> _addProof(BuildContext context) async {
    final controller = TextEditingController();
    final saved = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle preuve'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Commentaire'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    if (saved == null || saved.trim().isEmpty || !context.mounted) return;
    await context.read<ReportProvider>().addProof(
      reportId,
      Proof(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        type: ProofType.document,
        timestamp: DateTime.now(),
        comment: saved.trim(),
        reference: 'LOCAL-${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }
}
