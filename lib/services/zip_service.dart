import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

class ZipService {
  Uint8List buildZip(Map<String, List<int>> files) {
    final archive = Archive();
    for (final entry in files.entries) {
      archive.addFile(ArchiveFile(entry.key, entry.value.length, entry.value));
    }
    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  Uint8List textFile(String content) =>
      Uint8List.fromList(utf8.encode(content));
}
