import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/proof.dart';

class ProofTile extends StatelessWidget {
  const ProofTile({super.key, required this.proof});

  final Proof proof;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(_icon),
        title: Text('${proof.type.label} • ${proof.status.label}'),
        subtitle: Text(
          '${DateFormat('dd/MM/yyyy HH:mm').format(proof.timestamp)}\n${proof.comment}',
        ),
        isThreeLine: true,
        trailing: Text(proof.reference),
      ),
    );
  }

  IconData get _icon => switch (proof.type) {
    ProofType.screenshot => Icons.screenshot,
    ProofType.photo => Icons.photo_camera,
    ProofType.document => Icons.description,
    ProofType.link => Icons.link,
    ProofType.pdf => Icons.picture_as_pdf,
  };
}
