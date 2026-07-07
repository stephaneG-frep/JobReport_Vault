import 'package:csv/csv.dart';

import '../models/job_report.dart';

class CsvService {
  String buildReportsCsv(List<JobReport> reports) {
    final rows = [
      [
        'Titre',
        'Type',
        'Date',
        'Statut',
        'Priorité',
        'Entreprise',
        'Plateforme',
        'Résultat',
        'Activités',
        'Documents',
        'Preuves',
        'Temps minutes',
        'Tags',
      ],
      ...reports.map(
        (report) => [
          report.title,
          report.type.label,
          report.date.toIso8601String(),
          report.status.label,
          report.priority.label,
          report.company.name,
          report.platform,
          report.result,
          report.activities.length,
          report.attachments.length,
          report.proofs.length,
          report.durationMinutes,
          report.tags.join(', '),
        ],
      ),
    ];
    return const ListToCsvConverter().convert(rows);
  }
}
