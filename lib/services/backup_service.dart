import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../models/job_report.dart';
import '../models/settings.dart';
import 'json_service.dart';
import 'storage_service.dart';

class BackupService {
  BackupService(this._jsonService, this._storageService);

  final JsonService _jsonService;
  final StorageService _storageService;

  Future<String> createFullBackup(
    List<JobReport> reports,
    VaultSettings settings,
  ) async {
    final content = _jsonService.encodeBackup(reports, settings);
    final file = await _storageService.writeTextExport(
      _name('backup_full', 'json'),
      content,
    );
    return file.path;
  }

  Future<String> createIncrementalBackup(
    List<JobReport> reports,
    VaultSettings settings,
    DateTime since,
  ) async {
    final changed = reports.where((report) {
      final updated = report.updatedAt ?? report.date;
      return updated.isAfter(since);
    }).toList();
    final content = _jsonService.encodeBackup(changed, settings);
    final file = await _storageService.writeTextExport(
      _name('backup_incremental', 'json'),
      content,
    );
    return file.path;
  }

  List<JobReport> restoreReports(String source) =>
      _jsonService.decodeReports(source);

  Uint8List encryptedBytes(String content, String secret) {
    final key = sha256.convert(utf8.encode(secret)).bytes;
    final data = utf8.encode(content);
    return Uint8List.fromList([
      for (var i = 0; i < data.length; i++) data[i] ^ key[i % key.length],
    ]);
  }

  String _name(String prefix, String extension) =>
      '${prefix}_${DateTime.now().toIso8601String().replaceAll(':', '-')}.$extension';
}
