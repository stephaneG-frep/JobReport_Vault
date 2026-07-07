import 'dart:convert';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:web/web.dart' as web;

import '../models/attachment.dart';

class WebStoredFile {
  const WebStoredFile(this.path);
  final String path;
}

class StorageService {
  Future<WebStoredFile> writeExport(String fileName, List<int> bytes) async {
    final blob = web.Blob([Uint8List.fromList(bytes).toJS].toJS);
    final url = web.URL.createObjectURL(blob);
    web.HTMLAnchorElement()
      ..href = url
      ..download = fileName
      ..click();
    web.URL.revokeObjectURL(url);
    return WebStoredFile('Téléchargement navigateur : $fileName');
  }

  Future<WebStoredFile> writeTextExport(String fileName, String content) {
    return writeExport(fileName, utf8.encode(content));
  }

  Future<Attachment?> pickAndCopyAttachment() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    final picked = result?.files.single;
    if (picked == null) return null;
    return Attachment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: picked.name,
      type: _typeFromExtension(p.extension(picked.name).toLowerCase()),
      createdAt: DateTime.now(),
      path: 'web-local:${picked.name}',
      folder: 'Importés Web',
      sizeBytes: picked.size,
      previewNote: 'Métadonnées conservées localement dans le navigateur.',
    );
  }

  Future<Uint8List> readBytes(String path) async => Uint8List(0);

  AttachmentType _typeFromExtension(String extension) => switch (extension) {
    '.pdf' => AttachmentType.pdf,
    '.png' || '.jpg' || '.jpeg' || '.webp' => AttachmentType.image,
    '.doc' || '.docx' => AttachmentType.word,
    '.odt' || '.ods' || '.odp' => AttachmentType.libreOffice,
    '.zip' => AttachmentType.zip,
    _ => AttachmentType.other,
  };
}
