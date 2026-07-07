import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/report_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final settings = provider.settings;
    final trash = context.watch<ReportProvider>().trash;
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Mode sombre'),
            value: settings.darkMode,
            onChanged: (value) =>
                provider.update(settings.copyWith(darkMode: value)),
          ),
          SwitchListTile(
            title: const Text('Code PIN'),
            subtitle: const Text('Préférence locale de verrouillage'),
            value: settings.pinEnabled,
            onChanged: (value) =>
                provider.update(settings.copyWith(pinEnabled: value)),
          ),
          SwitchListTile(
            title: const Text('Mot de passe'),
            value: settings.passwordEnabled,
            onChanged: (value) =>
                provider.update(settings.copyWith(passwordEnabled: value)),
          ),
          SwitchListTile(
            title: const Text('Chiffrement local'),
            subtitle: const Text(
              'Exports sensibles et sauvegardes compatibles chiffrement applicatif',
            ),
            value: settings.localEncryption,
            onChanged: (value) =>
                provider.update(settings.copyWith(localEncryption: value)),
          ),
          SwitchListTile(
            title: const Text('Confirmation avant suppression'),
            value: settings.confirmBeforeDelete,
            onChanged: (value) =>
                provider.update(settings.copyWith(confirmBeforeDelete: value)),
          ),
          ListTile(
            leading: const Icon(Icons.lock_clock),
            title: const Text('Verrouillage automatique'),
            subtitle: Slider(
              value: settings.autoLockMinutes.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              label: '${settings.autoLockMinutes} min',
              onChanged: (value) => provider.update(
                settings.copyWith(autoLockMinutes: value.round()),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete),
            title: Text('Corbeille (${trash.length})'),
            subtitle: const Text(
              'Les rapports supprimés restent restaurables.',
            ),
          ),
          ...trash.map(
            (report) => Card(
              child: ListTile(
                title: Text(report.title),
                trailing: Wrap(
                  spacing: 8,
                  children: [
                    IconButton(
                      tooltip: 'Restaurer',
                      icon: const Icon(Icons.restore),
                      onPressed: () =>
                          context.read<ReportProvider>().restore(report.id),
                    ),
                    IconButton(
                      tooltip: 'Supprimer définitivement',
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () => context
                          .read<ReportProvider>()
                          .deleteForever(report.id),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
