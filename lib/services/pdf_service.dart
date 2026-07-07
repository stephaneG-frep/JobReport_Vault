import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/job_report.dart';
import '../models/statistics.dart';

class PdfService {
  Future<Uint8List> buildReportPdf(
    List<JobReport> reports,
    VaultStatistics stats,
  ) async {
    final document = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');
    document.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: 'JobReport Vault'),
          pw.Text('Synthèse locale des démarches de recherche d\'emploi'),
          pw.SizedBox(height: 16),
          pw.Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _metric('Rapports', stats.totalReports),
              _metric('Candidatures', stats.applicationCount),
              _metric('Relances', stats.followUpCount),
              _metric('Entretiens', stats.interviewCount),
              _metric('Preuves', stats.proofCount),
              _metric('Minutes', stats.totalMinutes),
            ],
          ),
          pw.SizedBox(height: 20),
          ...reports.map(
            (report) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 14),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    report.title,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    '${report.type.label} - ${dateFormat.format(report.date)}',
                  ),
                  pw.Text(
                    'Statut: ${report.status.label} | Priorité: ${report.priority.label}',
                  ),
                  if (report.company.name.isNotEmpty)
                    pw.Text('Entreprise: ${report.company.name}'),
                  pw.Text(report.description),
                  pw.Text(
                    'Activités: ${report.activities.length} | Documents: ${report.attachments.length} | Preuves: ${report.proofs.length}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return document.save();
  }

  pw.Widget _metric(String label, Object value) => pw.Container(
    padding: const pw.EdgeInsets.all(8),
    decoration: pw.BoxDecoration(border: pw.Border.all()),
    child: pw.Text('$label: $value'),
  );
}
