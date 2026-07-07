import 'package:flutter/material.dart';

import '../models/attachment.dart';

class AttachmentTile extends StatelessWidget {
  const AttachmentTile({super.key, required this.attachment});

  final Attachment attachment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_icon),
        title: Text(
          attachment.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${attachment.type.label} • ${attachment.folder}\n${attachment.previewNote}',
        ),
        isThreeLine: true,
        trailing: Text(_sizeLabel),
      ),
    );
  }

  IconData get _icon => switch (attachment.type) {
    AttachmentType.pdf => Icons.picture_as_pdf,
    AttachmentType.image ||
    AttachmentType.photo ||
    AttachmentType.screenshot => Icons.image,
    AttachmentType.zip => Icons.folder_zip,
    AttachmentType.cv ||
    AttachmentType.letter ||
    AttachmentType.word ||
    AttachmentType.libreOffice => Icons.description,
    _ => Icons.attach_file,
  };

  String get _sizeLabel {
    if (attachment.sizeBytes <= 0) {
      return '';
    }
    if (attachment.sizeBytes < 1024 * 1024) {
      return '${(attachment.sizeBytes / 1024).toStringAsFixed(0)} Ko';
    }
    return '${(attachment.sizeBytes / 1024 / 1024).toStringAsFixed(1)} Mo';
  }
}
