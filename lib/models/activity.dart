enum ActivityType {
  offerSearch,
  application,
  followUp,
  interview,
  phoneCall,
  email,
  sms,
  letter,
  videoCall,
  travel,
  jobForum,
  fair,
  workshop,
  training,
  technicalTest,
  other,
}

extension ActivityTypeLabel on ActivityType {
  String get label => switch (this) {
    ActivityType.offerSearch => "Recherche d'offres",
    ActivityType.application => 'Candidature',
    ActivityType.followUp => 'Relance',
    ActivityType.interview => 'Entretien',
    ActivityType.phoneCall => 'Appel téléphonique',
    ActivityType.email => 'Email',
    ActivityType.sms => 'SMS',
    ActivityType.letter => 'Courrier',
    ActivityType.videoCall => 'Visioconférence',
    ActivityType.travel => 'Déplacement',
    ActivityType.jobForum => 'Forum emploi',
    ActivityType.fair => 'Salon',
    ActivityType.workshop => 'Atelier',
    ActivityType.training => 'Formation',
    ActivityType.technicalTest => 'Test technique',
    ActivityType.other => 'Autre',
  };
}

class Activity {
  const Activity({
    required this.id,
    required this.type,
    required this.date,
    required this.durationMinutes,
    required this.description,
    this.company = '',
    this.contactPerson = '',
    this.result = '',
    this.observations = '',
  });

  final String id;
  final ActivityType type;
  final DateTime date;
  final int durationMinutes;
  final String description;
  final String company;
  final String contactPerson;
  final String result;
  final String observations;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'date': date.toIso8601String(),
    'durationMinutes': durationMinutes,
    'description': description,
    'company': company,
    'contactPerson': contactPerson,
    'result': result,
    'observations': observations,
  };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
    id: json['id'] as String,
    type: ActivityType.values.byName(json['type'] as String? ?? 'other'),
    date: DateTime.parse(json['date'] as String),
    durationMinutes: json['durationMinutes'] as int? ?? 0,
    description: json['description'] as String? ?? '',
    company: json['company'] as String? ?? '',
    contactPerson: json['contactPerson'] as String? ?? '',
    result: json['result'] as String? ?? '',
    observations: json['observations'] as String? ?? '',
  );
}
