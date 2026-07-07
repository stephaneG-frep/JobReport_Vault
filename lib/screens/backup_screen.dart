import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/report_provider.dart';
import '../providers/settings_provider.dart';
import '../services/backup_service.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sauvegarde')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: _full,
            icon: const Icon(Icons.backup),
            label: const Text('Sauvegarde complète'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: _incremental,
            icon: const Icon(Icons.update),
            label: const Text('Sauvegarde incrémentale'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => _message =
                  'La restauration accepte les sauvegardes JSON Career Suite via JsonService.',
            ),
            icon: const Icon(Icons.restore),
            label: const Text('Restauration'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => setState(
              () => _message =
                  'Import prêt pour les fichiers JSON/API locale de Career Suite.',
            ),
            icon: const Icon(Icons.input),
            label: const Text('Import'),
          ),
          if (_message.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_message),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _full() async {
    final path = await context.read<BackupService>().createFullBackup(
      context.read<ReportProvider>().reports,
      context.read<SettingsProvider>().settings,
    );
    setState(() => _message = 'Sauvegarde complète créée : $path');
  }

  Future<void> _incremental() async {
    final path = await context.read<BackupService>().createIncrementalBackup(
      context.read<ReportProvider>().reports,
      context.read<SettingsProvider>().settings,
      DateTime.now().subtract(const Duration(days: 7)),
    );
    setState(() => _message = 'Sauvegarde incrémentale créée : $path');
  }
}
