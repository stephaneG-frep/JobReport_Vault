import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/attachment_provider.dart';
import '../widgets/attachment_tile.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final attachments = context.watch<AttachmentProvider>().attachments;
    final folders = <String, int>{};
    for (final attachment in attachments) {
      folders.update(
        attachment.folder,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            children: folders.entries
                .map(
                  (entry) => Chip(label: Text('${entry.key} (${entry.value})')),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          if (attachments.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Aucun document archivé.'),
              ),
            )
          else
            ...attachments.map(
              (attachment) => AttachmentTile(attachment: attachment),
            ),
        ],
      ),
    );
  }
}
