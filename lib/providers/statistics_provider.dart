import 'package:flutter/foundation.dart';

import '../models/job_report.dart';
import '../models/settings.dart';
import '../models/statistics.dart';

class StatisticsProvider extends ChangeNotifier {
  VaultStatistics _statistics = VaultStatistics.fromReports(const []);

  VaultStatistics get statistics => _statistics;

  void rebuild(List<JobReport> reports, VaultSettings settings) {
    _statistics = VaultStatistics.fromReports(
      reports,
      lastExport: settings.lastExportAt,
    );
    notifyListeners();
  }
}
