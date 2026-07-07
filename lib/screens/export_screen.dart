import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/report_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/statistics_provider.dart';
import '../services/csv_service.dart';
import '../services/excel_service.dart';
import '../services/json_service.dart';
import '../services/pdf_service.dart';
import '../services/storage_service.dart';
import '../services/zip_service.dart';

class ExportScreen extends StatefulWidget {
  const ExportScreen({super.key});

  @override
  State<ExportScreen> createState() => _ExportScreenState();
}

class _ExportScreenState extends State<ExportScreen> {
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _button('Exporter PDF', Icons.picture_as_pdf, _exportPdf),
          _button('Exporter CSV', Icons.table_chart, _exportCsv),
          _button('Exporter Excel', Icons.grid_on, _exportExcel),
          _button('Exporter JSON', Icons.data_object, _exportJson),
          _button('Exporter ZIP complet', Icons.folder_zip, _exportZip),
          if (_message.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SelectableText(_message),
              ),
            ),
        ],
      ),
    );
  }

  Widget _button(String label, IconData icon, Future<void> Function() action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton.icon(
        onPressed: action,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  Future<void> _exportPdf() async {
    final reports = context.read<ReportProvider>().reports;
    final stats = context.read<StatisticsProvider>().statistics;
    final pdfService = context.read<PdfService>();
    final storageService = context.read<StorageService>();
    final bytes = await pdfService.buildReportPdf(reports, stats);
    final file = await storageService.writeExport(_name('pdf'), bytes);
    await _mark(file.path);
  }

  Future<void> _exportCsv() async {
    final content = context.read<CsvService>().buildReportsCsv(
      context.read<ReportProvider>().reports,
    );
    final file = await context.read<StorageService>().writeTextExport(
      _name('csv'),
      content,
    );
    await _mark(file.path);
  }

  Future<void> _exportExcel() async {
    final content = context.read<ExcelService>().buildExcelCompatibleHtml(
      context.read<ReportProvider>().reports,
    );
    final file = await context.read<StorageService>().writeTextExport(
      _name('xls'),
      content,
    );
    await _mark(file.path);
  }

  Future<void> _exportJson() async {
    final content = context.read<JsonService>().encodeReports(
      context.read<ReportProvider>().reports,
    );
    final file = await context.read<StorageService>().writeTextExport(
      _name('json'),
      content,
    );
    await _mark(file.path);
  }

  Future<void> _exportZip() async {
    final reports = context.read<ReportProvider>().reports;
    final stats = context.read<StatisticsProvider>().statistics;
    final pdfService = context.read<PdfService>();
    final csvService = context.read<CsvService>();
    final jsonService = context.read<JsonService>();
    final zipService = context.read<ZipService>();
    final storageService = context.read<StorageService>();
    final pdf = await pdfService.buildReportPdf(reports, stats);
    final csv = csvService.buildReportsCsv(reports);
    final json = jsonService.encodeReports(reports);
    final zip = zipService.buildZip({
      'rapport.pdf': pdf,
      'rapports.csv': utf8.encode(csv),
      'career_suite_export.json': utf8.encode(json),
    });
    final file = await storageService.writeExport(_name('zip'), zip);
    await _mark(file.path);
  }

  Future<void> _mark(String path) async {
    final settingsProvider = context.read<SettingsProvider>();
    await settingsProvider.markExported();
    if (!mounted) return;
    setState(() => _message = 'Export créé : $path');
  }

  String _name(String extension) =>
      'jobreport_vault_${DateTime.now().toIso8601String().replaceAll(':', '-')}.$extension';
}
