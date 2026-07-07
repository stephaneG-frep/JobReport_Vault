import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/attachment.dart';

class StorageService {
  Future<Directory> vaultDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final vault = Directory(p.join(directory.path, 'JobReportVault'));
    if (!vault.existsSync()) vault.createSync(recursive: true);
    return vault;
  }

  Future<File> writeExport(String fileName, List<int> bytes) async {
    final directory = await vaultDirectory();
    final exports = Directory(p.join(directory.path, 'exports'));
    if (!exports.existsSync()) exports.createSync(recursive: true);
    final file = File(p.join(exports.path, fileName));
    return file.writeAsBytes(bytes, flush: true);
  }

  Future<File> writeTextExport(String fileName, String content) async {
    final directory = await vaultDirectory();
    final exports = Directory(p.join(directory.path, 'exports'));
    if (!exports.existsSync()) exports.createSync(recursive: true);
    final file = File(p.join(exports.path, fileName));
    return file.writeAsString(content, flush: true);
  }

  Future<Attachment?> pickAndCopyAttachment() async {
    final result = await FilePicker.platform.pickFiles(withData: false);
    final picked = result?.files.single;
    final sourcePath = picked?.path;
    if (picked == null || sourcePath == null) return null;
    final directory = await vaultDirectory();
    final attachments = Directory(p.join(directory.path, 'attachments'));
    if (!attachments.existsSync()) attachments.createSync(recursive: true);
    final safeName = '${DateTime.now().millisecondsSinceEpoch}_${picked.name}';
    final destination = p.join(attachments.path, safeName);
    await File(sourcePath).copy(destination);
    return Attachment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: picked.name,
      type: _typeFromExtension(p.extension(picked.name).toLowerCase()),
      createdAt: DateTime.now(),
      path: destination,
      folder: 'Importés',
      sizeBytes: picked.size,
      previewNote: 'Fichier copié dans le coffre local.',
    );
  }

  Future<Uint8List> readBytes(String path) => File(path).readAsBytes();

  AttachmentType _typeFromExtension(String extension) => switch (extension) {
    '.pdf' => AttachmentType.pdf,
    '.png' || '.jpg' || '.jpeg' || '.webp' => AttachmentType.image,
    '.doc' || '.docx' => AttachmentType.word,
    '.odt' || '.ods' || '.odp' => AttachmentType.libreOffice,
    '.zip' => AttachmentType.zip,
    _ => AttachmentType.other,
  };
}
