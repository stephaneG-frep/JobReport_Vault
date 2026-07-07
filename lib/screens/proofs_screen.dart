import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/report_provider.dart';
import '../widgets/proof_tile.dart';

class ProofsScreen extends StatelessWidget {
  const ProofsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final proofs = context.watch<ReportProvider>().proofs;
    return Scaffold(
      appBar: AppBar(title: const Text('Preuves')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: proofs.isEmpty
            ? [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Aucune preuve enregistrée.'),
                  ),
                ),
              ]
            : proofs.map((proof) => ProofTile(proof: proof)).toList(),
      ),
    );
  }
}
