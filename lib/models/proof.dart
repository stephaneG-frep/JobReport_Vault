enum ProofType { screenshot, photo, document, link, pdf }

enum ProofStatus { toVerify, validated, refused }

extension ProofTypeLabel on ProofType {
  String get label => switch (this) {
    ProofType.screenshot => "Capture d'écran",
    ProofType.photo => 'Photo',
    ProofType.document => 'Document',
    ProofType.link => 'Lien',
    ProofType.pdf => 'PDF',
  };
}

extension ProofStatusLabel on ProofStatus {
  String get label => switch (this) {
    ProofStatus.toVerify => 'À vérifier',
    ProofStatus.validated => 'Validée',
    ProofStatus.refused => 'Refusée',
  };
}

class Proof {
  const Proof({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.comment,
    this.status = ProofStatus.toVerify,
    this.reference = '',
  });

  final String id;
  final ProofType type;
  final DateTime timestamp;
  final String comment;
  final ProofStatus status;
  final String reference;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'timestamp': timestamp.toIso8601String(),
    'comment': comment,
    'status': status.name,
    'reference': reference,
  };

  factory Proof.fromJson(Map<String, dynamic> json) => Proof(
    id: json['id'] as String,
    type: ProofType.values.byName(json['type'] as String? ?? 'document'),
    timestamp: DateTime.parse(json['timestamp'] as String),
    comment: json['comment'] as String? ?? '',
    status: ProofStatus.values.byName(json['status'] as String? ?? 'toVerify'),
    reference: json['reference'] as String? ?? '',
  );
}
