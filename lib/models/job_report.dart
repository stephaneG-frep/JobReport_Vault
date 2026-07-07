import 'activity.dart';
import 'attachment.dart';
import 'company.dart';
import 'proof.dart';

enum ReportType {
  daily,
  weekly,
  monthly,
  application,
  followUp,
  interview,
  training,
  franceTravail,
  missionLocale,
  capEmploi,
  administrative,
  free,
}

enum ReportStatus { draft, inProgress, validated, archived }

enum ReportPriority { low, normal, high, urgent }

extension ReportTypeLabel on ReportType {
  String get label => switch (this) {
    ReportType.daily => 'Rapport quotidien',
    ReportType.weekly => 'Rapport hebdomadaire',
    ReportType.monthly => 'Rapport mensuel',
    ReportType.application => 'Rapport de candidature',
    ReportType.followUp => 'Rapport de relance',
    ReportType.interview => "Rapport d'entretien",
    ReportType.training => 'Rapport de formation',
    ReportType.franceTravail => 'Rapport France Travail',
    ReportType.missionLocale => 'Rapport Mission Locale',
    ReportType.capEmploi => 'Rapport Cap Emploi',
    ReportType.administrative => 'Rapport administratif',
    ReportType.free => 'Rapport libre',
  };
}

extension ReportStatusLabel on ReportStatus {
  String get label => switch (this) {
    ReportStatus.draft => 'Brouillon',
    ReportStatus.inProgress => 'En cours',
    ReportStatus.validated => 'Validé',
    ReportStatus.archived => 'Archivé',
  };
}

extension ReportPriorityLabel on ReportPriority {
  String get label => switch (this) {
    ReportPriority.low => 'Faible',
    ReportPriority.normal => 'Normale',
    ReportPriority.high => 'Haute',
    ReportPriority.urgent => 'Urgente',
  };
}

class JobReport {
  const JobReport({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.period,
    required this.author,
    required this.type,
    required this.status,
    required this.priority,
    this.personalNotes = '',
    this.comments = '',
    this.tags = const [],
    this.company = const Company(),
    this.activities = const [],
    this.attachments = const [],
    this.proofs = const [],
    this.platform = '',
    this.result = '',
    this.updatedAt,
    this.deletedAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String period;
  final String author;
  final ReportType type;
  final ReportStatus status;
  final ReportPriority priority;
  final String personalNotes;
  final String comments;
  final List<String> tags;
  final Company company;
  final List<Activity> activities;
  final List<Attachment> attachments;
  final List<Proof> proofs;
  final String platform;
  final String result;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;
  int get durationMinutes =>
      activities.fold(0, (total, activity) => total + activity.durationMinutes);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'period': period,
    'author': author,
    'type': type.name,
    'status': status.name,
    'priority': priority.name,
    'personalNotes': personalNotes,
    'comments': comments,
    'tags': tags,
    'company': company.toJson(),
    'activities': activities.map((activity) => activity.toJson()).toList(),
    'attachments': attachments
        .map((attachment) => attachment.toJson())
        .toList(),
    'proofs': proofs.map((proof) => proof.toJson()).toList(),
    'platform': platform,
    'result': result,
    'updatedAt': updatedAt?.toIso8601String(),
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory JobReport.fromJson(Map<String, dynamic> json) => JobReport(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    date: DateTime.parse(json['date'] as String),
    period: json['period'] as String? ?? '',
    author: json['author'] as String? ?? '',
    type: ReportType.values.byName(json['type'] as String? ?? 'free'),
    status: ReportStatus.values.byName(json['status'] as String? ?? 'draft'),
    priority: ReportPriority.values.byName(
      json['priority'] as String? ?? 'normal',
    ),
    personalNotes: json['personalNotes'] as String? ?? '',
    comments: json['comments'] as String? ?? '',
    tags: (json['tags'] as List<dynamic>? ?? const []).cast<String>(),
    company: Company.fromJson(
      Map<String, dynamic>.from(json['company'] as Map? ?? const {}),
    ),
    activities: (json['activities'] as List<dynamic>? ?? const [])
        .map(
          (item) => Activity.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
    attachments: (json['attachments'] as List<dynamic>? ?? const [])
        .map(
          (item) => Attachment.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(),
    proofs: (json['proofs'] as List<dynamic>? ?? const [])
        .map((item) => Proof.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList(),
    platform: json['platform'] as String? ?? '',
    result: json['result'] as String? ?? '',
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    deletedAt: json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String),
  );

  JobReport copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? period,
    String? author,
    ReportType? type,
    ReportStatus? status,
    ReportPriority? priority,
    String? personalNotes,
    String? comments,
    List<String>? tags,
    Company? company,
    List<Activity>? activities,
    List<Attachment>? attachments,
    List<Proof>? proofs,
    String? platform,
    String? result,
    DateTime? updatedAt,
    Object? deletedAt = _unchanged,
  }) => JobReport(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    date: date ?? this.date,
    period: period ?? this.period,
    author: author ?? this.author,
    type: type ?? this.type,
    status: status ?? this.status,
    priority: priority ?? this.priority,
    personalNotes: personalNotes ?? this.personalNotes,
    comments: comments ?? this.comments,
    tags: tags ?? this.tags,
    company: company ?? this.company,
    activities: activities ?? this.activities,
    attachments: attachments ?? this.attachments,
    proofs: proofs ?? this.proofs,
    platform: platform ?? this.platform,
    result: result ?? this.result,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: identical(deletedAt, _unchanged)
        ? this.deletedAt
        : deletedAt as DateTime?,
  );
}

const Object _unchanged = Object();
