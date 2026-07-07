import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/company.dart';
import '../models/job_report.dart';
import '../providers/report_provider.dart';
import '../providers/settings_provider.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key, this.report});

  final JobReport? report;

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _description;
  late final TextEditingController _period;
  late final TextEditingController _author;
  late final TextEditingController _notes;
  late final TextEditingController _comments;
  late final TextEditingController _tags;
  late final TextEditingController _company;
  late final TextEditingController _city;
  late final TextEditingController _recruiter;
  late final TextEditingController _position;
  late final TextEditingController _platform;
  late final TextEditingController _result;
  late DateTime _date;
  late ReportType _type;
  late ReportStatus _status;
  late ReportPriority _priority;

  @override
  void initState() {
    super.initState();
    final report = widget.report;
    _title = TextEditingController(text: report?.title ?? '');
    _description = TextEditingController(text: report?.description ?? '');
    _period = TextEditingController(text: report?.period ?? '');
    _author = TextEditingController(text: report?.author ?? '');
    _notes = TextEditingController(text: report?.personalNotes ?? '');
    _comments = TextEditingController(text: report?.comments ?? '');
    _tags = TextEditingController(text: report?.tags.join(', ') ?? '');
    _company = TextEditingController(text: report?.company.name ?? '');
    _city = TextEditingController(text: report?.company.city ?? '');
    _recruiter = TextEditingController(
      text: report?.company.recruiterName ?? '',
    );
    _position = TextEditingController(text: report?.company.position ?? '');
    _platform = TextEditingController(text: report?.platform ?? '');
    _result = TextEditingController(text: report?.result ?? '');
    _date = report?.date ?? DateTime.now();
    _type = report?.type ?? ReportType.daily;
    _status = report?.status ?? ReportStatus.draft;
    _priority = report?.priority ?? ReportPriority.normal;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_author.text.isEmpty) {
      _author.text = context.read<SettingsProvider>().settings.authorName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.report == null ? 'Nouveau rapport' : 'Modifier le rapport',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_title, 'Titre', required: true),
            _field(_description, 'Description', lines: 3),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _dropdown(
                  'Type',
                  _type,
                  ReportType.values,
                  (v) => v.label,
                  (v) => setState(() => _type = v!),
                ),
                _dropdown(
                  'Statut',
                  _status,
                  ReportStatus.values,
                  (v) => v.label,
                  (v) => setState(() => _status = v!),
                ),
                _dropdown(
                  'Priorité',
                  _priority,
                  ReportPriority.values,
                  (v) => v.label,
                  (v) => setState(() => _priority = v!),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event),
              title: Text(
                '${_date.day}/${_date.month}/${_date.year} ${_date.hour.toString().padLeft(2, '0')}:${_date.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.edit_calendar),
              onTap: _pickDate,
            ),
            _field(_period, 'Période concernée'),
            _field(_author, 'Auteur'),
            _field(_company, 'Entreprise'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(width: 260, child: _field(_city, 'Ville')),
                SizedBox(
                  width: 260,
                  child: _field(_recruiter, 'Nom du recruteur'),
                ),
                SizedBox(
                  width: 260,
                  child: _field(_position, 'Poste concerné'),
                ),
              ],
            ),
            _field(_platform, 'Plateforme'),
            _field(_result, 'Résultat'),
            _field(_notes, 'Notes personnelles', lines: 3),
            _field(_comments, 'Commentaires', lines: 3),
            _field(_tags, 'Tags séparés par des virgules'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: const Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int lines = 1,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: lines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: required
            ? (value) =>
                  value == null || value.trim().isEmpty ? 'Champ requis' : null
            : null,
      ),
    );
  }

  Widget _dropdown<T>(
    String label,
    T value,
    List<T> values,
    String Function(T) text,
    ValueChanged<T?> onChanged,
  ) {
    return SizedBox(
      width: 260,
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: values
            .map(
              (item) => DropdownMenuItem(value: item, child: Text(text(item))),
            )
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: _date,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_date),
    );
    setState(() {
      _date = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? _date.hour,
        time?.minute ?? _date.minute,
      );
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final existing = widget.report;
    final report = JobReport(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _title.text.trim(),
      description: _description.text.trim(),
      date: _date,
      period: _period.text.trim(),
      author: _author.text.trim(),
      type: _type,
      status: _status,
      priority: _priority,
      personalNotes: _notes.text.trim(),
      comments: _comments.text.trim(),
      tags: _tags.text
          .split(',')
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toList(),
      company: Company(
        name: _company.text.trim(),
        city: _city.text.trim(),
        recruiterName: _recruiter.text.trim(),
        position: _position.text.trim(),
      ),
      activities: existing?.activities ?? const [],
      attachments: existing?.attachments ?? const [],
      proofs: existing?.proofs ?? const [],
      platform: _platform.text.trim(),
      result: _result.text.trim(),
    );
    await context.read<ReportProvider>().save(report);
    if (mounted) Navigator.pop(context);
  }
}
