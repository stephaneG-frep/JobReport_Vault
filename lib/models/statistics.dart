import 'activity.dart';
import 'job_report.dart';

class VaultStatistics {
  const VaultStatistics({
    required this.totalReports,
    required this.monthReports,
    required this.weekReports,
    required this.lastActivity,
    required this.lastExport,
    required this.proofCount,
    required this.applicationCount,
    required this.followUpCount,
    required this.interviewCount,
    required this.totalMinutes,
    required this.companiesContacted,
    required this.platformsUsed,
    required this.documentsArchived,
    required this.reportsByType,
    required this.activitiesByDay,
  });

  final int totalReports;
  final int monthReports;
  final int weekReports;
  final DateTime? lastActivity;
  final DateTime? lastExport;
  final int proofCount;
  final int applicationCount;
  final int followUpCount;
  final int interviewCount;
  final int totalMinutes;
  final int companiesContacted;
  final int platformsUsed;
  final int documentsArchived;
  final Map<String, int> reportsByType;
  final Map<DateTime, int> activitiesByDay;

  String get totalTimeLabel {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes.toString().padLeft(2, '0')}';
  }

  factory VaultStatistics.fromReports(
    List<JobReport> reports, {
    DateTime? lastExport,
  }) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final companies = <String>{};
    final platforms = <String>{};
    final reportsByType = <String, int>{};
    final activitiesByDay = <DateTime, int>{};
    DateTime? lastActivity;
    var proofs = 0;
    var applications = 0;
    var followUps = 0;
    var interviews = 0;
    var minutes = 0;
    var documents = 0;

    for (final report in reports.where((report) => !report.isDeleted)) {
      reportsByType.update(
        report.type.label,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
      if (report.company.name.isNotEmpty) companies.add(report.company.name);
      if (report.platform.isNotEmpty) platforms.add(report.platform);
      proofs += report.proofs.length;
      documents += report.attachments.length;
      minutes += report.durationMinutes;
      for (final activity in report.activities) {
        if (lastActivity == null || activity.date.isAfter(lastActivity)) {
          lastActivity = activity.date;
        }
        final day = DateTime(
          activity.date.year,
          activity.date.month,
          activity.date.day,
        );
        activitiesByDay.update(day, (value) => value + 1, ifAbsent: () => 1);
        switch (activity.type) {
          case ActivityType.application:
            applications++;
          case ActivityType.followUp:
            followUps++;
          case ActivityType.interview:
            interviews++;
          default:
            break;
        }
      }
    }

    final activeReports = reports.where((report) => !report.isDeleted).toList();
    return VaultStatistics(
      totalReports: activeReports.length,
      monthReports: activeReports
          .where(
            (report) =>
                report.date.year == now.year && report.date.month == now.month,
          )
          .length,
      weekReports: activeReports
          .where(
            (report) => report.date.isAfter(
              weekStart.subtract(const Duration(days: 1)),
            ),
          )
          .length,
      lastActivity: lastActivity,
      lastExport: lastExport,
      proofCount: proofs,
      applicationCount: applications,
      followUpCount: followUps,
      interviewCount: interviews,
      totalMinutes: minutes,
      companiesContacted: companies.length,
      platformsUsed: platforms.length,
      documentsArchived: documents,
      reportsByType: reportsByType,
      activitiesByDay: activitiesByDay,
    );
  }
}
