import 'dart:convert';

import '../models/job_report.dart';
import '../models/settings.dart';

class JsonService {
  String encodeReports(List<JobReport> reports) {
    return const JsonEncoder.withIndent('  ').convert({
      'schema': 'career_suite.jobreport_vault.v1',
      'generatedAt': DateTime.now().toIso8601String(),
      'reports': reports.map((report) => report.toJson()).toList(),
    });
  }

  List<JobReport> decodeReports(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return (json['reports'] as List<dynamic>? ?? const [])
        .map(
          (item) => JobReport.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }

  String encodeBackup(List<JobReport> reports, VaultSettings settings) {
    return const JsonEncoder.withIndent('  ').convert({
      'schema': 'career_suite.jobreport_vault.backup.v1',
      'generatedAt': DateTime.now().toIso8601String(),
      'settings': settings.toJson(),
      'reports': reports.map((report) => report.toJson()).toList(),
    });
  }
}
