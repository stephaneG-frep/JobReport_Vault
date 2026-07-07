import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'providers/activity_provider.dart';
import 'providers/attachment_provider.dart';
import 'providers/report_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/statistics_provider.dart';
import 'services/backup_service.dart';
import 'services/csv_service.dart';
import 'services/database_service.dart';
import 'services/excel_service.dart';
import 'services/json_service.dart';
import 'services/pdf_service.dart';
import 'services/storage_service.dart';
import 'services/zip_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final databaseService = DatabaseService();
  await databaseService.init();
  final jsonService = JsonService();
  final storageService = StorageService();
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: databaseService),
        Provider.value(value: storageService),
        Provider.value(value: jsonService),
        Provider(create: (_) => CsvService()),
        Provider(create: (_) => ExcelService()),
        Provider(create: (_) => PdfService()),
        Provider(create: (_) => ZipService()),
        Provider(create: (_) => BackupService(jsonService, storageService)),
        ChangeNotifierProvider(
          create: (_) => ReportProvider(databaseService)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(databaseService)..load(),
        ),
        ChangeNotifierProxyProvider<ReportProvider, ActivityProvider>(
          create: (_) => ActivityProvider(),
          update: (_, reports, provider) =>
              (provider ?? ActivityProvider())..replace(reports.activities),
        ),
        ChangeNotifierProxyProvider<ReportProvider, AttachmentProvider>(
          create: (_) => AttachmentProvider(),
          update: (_, reports, provider) =>
              (provider ?? AttachmentProvider())..replace(reports.attachments),
        ),
        ChangeNotifierProxyProvider2<
          ReportProvider,
          SettingsProvider,
          StatisticsProvider
        >(
          create: (_) => StatisticsProvider(),
          update: (_, reports, settings, provider) =>
              (provider ?? StatisticsProvider())
                ..rebuild(reports.reports, settings.settings),
        ),
      ],
      child: const JobReportVaultApp(),
    ),
  );
}
