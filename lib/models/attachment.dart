enum AttachmentType {
  pdf,
  image,
  photo,
  screenshot,
  cv,
  letter,
  diploma,
  contract,
  exportedEmail,
  exportedSms,
  word,
  libreOffice,
  zip,
  other,
}

extension AttachmentTypeLabel on AttachmentType {
  String get label => switch (this) {
    AttachmentType.pdf => 'PDF',
    AttachmentType.image => 'Image',
    AttachmentType.photo => 'Photo',
    AttachmentType.screenshot => "Capture d'écran",
    AttachmentType.cv => 'CV',
    AttachmentType.letter => 'Lettre',
    AttachmentType.diploma => 'Diplôme',
    AttachmentType.contract => 'Contrat',
    AttachmentType.exportedEmail => 'Email exporté',
    AttachmentType.exportedSms => 'SMS exporté',
    AttachmentType.word => 'Document Word',
    AttachmentType.libreOffice => 'Document LibreOffice',
    AttachmentType.zip => 'Archive ZIP',
    AttachmentType.other => 'Autre',
  };
}

class Attachment {
  const Attachment({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    this.path = '',
    this.folder = 'Général',
    this.mimeType = '',
    this.sizeBytes = 0,
    this.previewNote = '',
  });

  final String id;
  final String name;
  final AttachmentType type;
  final DateTime createdAt;
  final String path;
  final String folder;
  final String mimeType;
  final int sizeBytes;
  final String previewNote;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'createdAt': createdAt.toIso8601String(),
    'path': path,
    'folder': folder,
    'mimeType': mimeType,
    'sizeBytes': sizeBytes,
    'previewNote': previewNote,
  };

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    type: AttachmentType.values.byName(json['type'] as String? ?? 'other'),
    createdAt: DateTime.parse(json['createdAt'] as String),
    path: json['path'] as String? ?? '',
    folder: json['folder'] as String? ?? 'Général',
    mimeType: json['mimeType'] as String? ?? '',
    sizeBytes: json['sizeBytes'] as int? ?? 0,
    previewNote: json['previewNote'] as String? ?? '',
  );
}
