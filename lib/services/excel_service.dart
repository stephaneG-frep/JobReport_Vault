import '../models/job_report.dart';

class ExcelService {
  String buildExcelCompatibleHtml(List<JobReport> reports) {
    final rows = reports.map((report) {
      return '<tr><td>${_e(report.title)}</td><td>${_e(report.type.label)}</td>'
          '<td>${report.date.toIso8601String()}</td><td>${_e(report.company.name)}</td>'
          '<td>${_e(report.status.label)}</td><td>${report.durationMinutes}</td></tr>';
    }).join();
    return '''
<html>
<head><meta charset="utf-8"></head>
<body>
<table>
<tr><th>Titre</th><th>Type</th><th>Date</th><th>Entreprise</th><th>Statut</th><th>Minutes</th></tr>
$rows
</table>
</body>
</html>
''';
  }

  String _e(String value) => value
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}
