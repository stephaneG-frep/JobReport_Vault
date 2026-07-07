import 'package:flutter/foundation.dart';

import '../models/activity.dart';
import '../models/attachment.dart';
import '../models/job_report.dart';
import '../models/proof.dart';
import '../services/database_service.dart';

class ReportProvider extends ChangeNotifier {
  ReportProvider(this._databaseService);

  final DatabaseService _databaseService;
  List<JobReport> _reports = [];
  String _query = '';
  ReportType? _typeFilter;
  ReportStatus? _statusFilter;
  ReportPriority? _priorityFilter;

  List<JobReport> get reports =>
      _reports.where((report) => !report.isDeleted).toList();
  List<JobReport> get trash =>
      _reports.where((report) => report.isDeleted).toList();
  String get query => _query;
  ReportType? get typeFilter => _typeFilter;
  ReportStatus? get statusFilter => _statusFilter;
  ReportPriority? get priorityFilter => _priorityFilter;

  List<Activity> get activities =>
      reports.expand((report) => report.activities).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
  List<Attachment> get attachments =>
      reports.expand((report) => report.attachments).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  List<Proof> get proofs =>
      reports.expand((report) => report.proofs).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  List<JobReport> get filteredReports {
    final needle = _query.trim().toLowerCase();
    return reports.where((report) {
      final searchable = [
        report.title,
        report.description,
        report.type.label,
        report.company.name,
        report.personalNotes,
        report.comments,
        report.tags.join(' '),
        report.result,
        ...report.attachments.map((item) => item.name),
      ].join(' ').toLowerCase();
      return (needle.isEmpty || searchable.contains(needle)) &&
          (_typeFilter == null || report.type == _typeFilter) &&
          (_statusFilter == null || report.status == _statusFilter) &&
          (_priorityFilter == null || report.priority == _priorityFilter);
    }).toList();
  }

  Future<void> load() async {
    _reports = _databaseService.getReports(includeDeleted: true);
    notifyListeners();
  }

  Future<void> save(JobReport report) async {
    await _databaseService.saveReport(report);
    await load();
  }

  Future<void> moveToTrash(String id) async {
    await _databaseService.moveToTrash(id);
    await load();
  }

  Future<void> restore(String id) async {
    await _databaseService.restoreFromTrash(id);
    await load();
  }

  Future<void> deleteForever(String id) async {
    await _databaseService.deleteForever(id);
    await load();
  }

  Future<void> addActivity(String reportId, Activity activity) async {
    final report = _reports.firstWhere((item) => item.id == reportId);
    await save(report.copyWith(activities: [...report.activities, activity]));
  }

  Future<void> addAttachment(String reportId, Attachment attachment) async {
    final report = _reports.firstWhere((item) => item.id == reportId);
    await save(
      report.copyWith(attachments: [...report.attachments, attachment]),
    );
  }

  Future<void> addProof(String reportId, Proof proof) async {
    final report = _reports.firstWhere((item) => item.id == reportId);
    await save(report.copyWith(proofs: [...report.proofs, proof]));
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setFilters({
    ReportType? type,
    ReportStatus? status,
    ReportPriority? priority,
    bool clear = false,
  }) {
    _typeFilter = clear ? null : type;
    _statusFilter = clear ? null : status;
    _priorityFilter = clear ? null : priority;
    notifyListeners();
  }
}
