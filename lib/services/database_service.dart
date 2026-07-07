import 'package:hive_flutter/hive_flutter.dart';

import '../models/activity.dart';
import '../models/attachment.dart';
import '../models/company.dart';
import '../models/job_report.dart';
import '../models/proof.dart';
import '../models/settings.dart';

class DatabaseService {
  static const reportsBoxName = 'job_reports';
  static const settingsBoxName = 'vault_settings';
  static const metaBoxName = 'vault_meta';

  late Box<Map> _reportsBox;
  late Box<Map> _settingsBox;
  late Box _metaBox;

  Future<void> init() async {
    await Hive.initFlutter('jobreport_vault');
    _reportsBox = await Hive.openBox<Map>(reportsBoxName);
    _settingsBox = await Hive.openBox<Map>(settingsBoxName);
    _metaBox = await Hive.openBox(metaBoxName);
    if (_metaBox.get('demoSeeded') != true) {
      await seedDemoData();
      await _metaBox.put('demoSeeded', true);
    }
  }

  List<JobReport> getReports({bool includeDeleted = false}) {
    final reports =
        _reportsBox.values
            .map((item) => JobReport.fromJson(Map<String, dynamic>.from(item)))
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    return includeDeleted
        ? reports
        : reports.where((report) => !report.isDeleted).toList();
  }

  Future<void> saveReport(JobReport report) async {
    await _reportsBox.put(
      report.id,
      report.copyWith(updatedAt: DateTime.now()).toJson(),
    );
  }

  Future<void> saveReports(List<JobReport> reports) async {
    final entries = {for (final report in reports) report.id: report.toJson()};
    await _reportsBox.putAll(entries);
  }

  Future<void> moveToTrash(String id) async {
    final report = _reportsBox.get(id);
    if (report == null) return;
    final parsed = JobReport.fromJson(Map<String, dynamic>.from(report));
    await saveReport(parsed.copyWith(deletedAt: DateTime.now()));
  }

  Future<void> restoreFromTrash(String id) async {
    final report = _reportsBox.get(id);
    if (report == null) return;
    final parsed = JobReport.fromJson(Map<String, dynamic>.from(report));
    await _reportsBox.put(id, parsed.toJson()..['deletedAt'] = null);
  }

  Future<void> deleteForever(String id) => _reportsBox.delete(id);

  VaultSettings getSettings() {
    final json = _settingsBox.get('settings');
    if (json == null) return const VaultSettings();
    return VaultSettings.fromJson(Map<String, dynamic>.from(json));
  }

  Future<void> saveSettings(VaultSettings settings) =>
      _settingsBox.put('settings', settings.toJson());

  Future<void> seedDemoData() async {
    final now = DateTime.now();
    final companies = [
      const Company(
        name: 'NovaTech',
        city: 'Lyon',
        email: 'rh@novatech.example',
        recruiterName: 'Claire Martin',
        position: 'Développeur Flutter',
        offerUrl: 'https://example.com/offres/flutter',
        website: 'https://novatech.example',
      ),
      const Company(
        name: 'Atelier Data',
        city: 'Paris',
        email: 'jobs@atelierdata.example',
        recruiterName: 'Samir Benali',
        position: 'Assistant data',
        website: 'https://atelierdata.example',
      ),
      const Company(
        name: 'GreenLog',
        city: 'Nantes',
        phone: '02 00 00 00 00',
        recruiterName: 'Inès Laurent',
        position: 'Chargé support',
      ),
    ];
    final reports = List<JobReport>.generate(20, (index) {
      final date = now.subtract(Duration(days: index * 2));
      final company = companies[index % companies.length];
      final activities = <Activity>[
        Activity(
          id: _id('act-$index-a'),
          type: index < 15
              ? ActivityType.application
              : ActivityType.offerSearch,
          date: date,
          durationMinutes: 45 + (index % 4) * 15,
          description: index < 15
              ? 'Candidature envoyée pour ${company.position}.'
              : "Recherche ciblée d'offres sur les plateformes emploi.",
          company: company.name,
          contactPerson: company.recruiterName,
          result: index % 3 == 0 ? 'Réponse attendue' : 'À suivre',
          observations: 'Action consignée pour justificatif.',
        ),
        if (index < 10)
          Activity(
            id: _id('act-$index-r'),
            type: ActivityType.followUp,
            date: date.add(const Duration(hours: 3)),
            durationMinutes: 20,
            description: 'Relance effectuée par email.',
            company: company.name,
            contactPerson: company.recruiterName,
            result: 'Relance enregistrée',
          ),
        if (index < 6)
          Activity(
            id: _id('act-$index-i'),
            type: ActivityType.interview,
            date: date.add(const Duration(days: 1, hours: 10)),
            durationMinutes: 60,
            description: "Entretien de suivi avec le recruteur.",
            company: company.name,
            contactPerson: company.recruiterName,
            result: index.isEven ? 'Second échange prévu' : 'Retour en attente',
          ),
        if (index < 5)
          Activity(
            id: _id('act-$index-f'),
            type: ActivityType.training,
            date: date.add(const Duration(hours: 5)),
            durationMinutes: 90,
            description: 'Formation courte liée aux techniques de candidature.',
            result: 'Compétence renforcée',
          ),
      ];
      return JobReport(
        id: _id('report-$index'),
        title: 'Suivi recherche emploi #${index + 1}',
        description:
            'Rapport détaillant les démarches réalisées, documents associés et résultats obtenus.',
        date: date,
        period: index % 3 == 0
            ? 'Semaine ${date.weekday}'
            : '${date.month}/${date.year}',
        author: 'Utilisateur',
        type: ReportType.values[index % ReportType.values.length],
        status: ReportStatus.values[index % ReportStatus.values.length],
        priority: ReportPriority.values[index % ReportPriority.values.length],
        personalNotes: 'Note personnelle sur les prochaines actions.',
        comments: 'Commentaire utile pour conseiller ou organisme.',
        tags: [
          'emploi',
          if (index < 15) 'candidature',
          company.city.toLowerCase(),
        ],
        company: company,
        activities: activities,
        attachments: [
          Attachment(
            id: _id('att-$index'),
            name: index.isEven
                ? 'CV_cible_$index.pdf'
                : 'capture_offre_$index.png',
            type: index.isEven ? AttachmentType.cv : AttachmentType.screenshot,
            createdAt: date,
            folder: index.isEven ? 'CV' : 'Captures',
            previewNote:
                'Prévisualisation disponible via les métadonnées locales.',
            sizeBytes: 128000 + index * 2048,
          ),
        ],
        proofs: [
          Proof(
            id: _id('proof-$index'),
            type: index.isEven ? ProofType.pdf : ProofType.screenshot,
            timestamp: date,
            comment: 'Preuve horodatée de la démarche.',
            status: index % 4 == 0
                ? ProofStatus.toVerify
                : ProofStatus.validated,
            reference: 'REF-${1000 + index}',
          ),
        ],
        platform: ['France Travail', 'LinkedIn', 'Indeed', 'APEC'][index % 4],
        result: index % 3 == 0 ? 'Réponse positive' : 'En attente',
      );
    });
    await saveReports(reports);
  }

  String _id(String value) => '${DateTime.now().microsecondsSinceEpoch}-$value';
}
