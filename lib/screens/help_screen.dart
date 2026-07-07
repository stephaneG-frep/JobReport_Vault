import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Aide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('JobReport Vault', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(
                    "Coffre local pour conserver les démarches, rapports, preuves et exports liés à une recherche d'emploi.",
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const _HelpSection(
            icon: Icons.article_outlined,
            title: 'Créer un rapport',
            items: [
              'Ouvrir Rapports puis toucher Créer.',
              'Choisir le type, la période, le statut et la priorité.',
              'Associer une entreprise, une plateforme, des tags et un résultat.',
            ],
          ),
          const _HelpSection(
            icon: Icons.task_alt_outlined,
            title: 'Ajouter des activités',
            items: [
              'Ouvrir un rapport puis Ajouter une activité.',
              'Utiliser les activités pour tracer candidatures, relances, entretiens, appels, emails, formations ou déplacements.',
              'Le temps saisi alimente automatiquement les statistiques.',
            ],
          ),
          const _HelpSection(
            icon: Icons.folder_outlined,
            title: 'Archiver documents et preuves',
            items: [
              'Depuis un rapport, Joindre un document copie le fichier dans le coffre local.',
              'Ajouter une preuve permet de garder un horodatage, un commentaire et un état de vérification.',
              'Les écrans Documents et Preuves donnent une vue globale de tout ce qui est enregistré.',
            ],
          ),
          const _HelpSection(
            icon: Icons.search,
            title: 'Rechercher et filtrer',
            items: [
              'La recherche couvre titre, entreprise, type, description, notes, commentaires, tags, résultat et documents.',
              'Les filtres permettent de réduire la liste par type, statut et priorité.',
              'Les longues valeurs sont abrégées sur mobile pour éviter les débordements.',
            ],
          ),
          const _HelpSection(
            icon: Icons.ios_share_outlined,
            title: 'Exporter',
            items: [
              'PDF pour une synthèse lisible.',
              'CSV et Excel pour tableur.',
              'JSON et ZIP pour sauvegarde ou échange avec les apps Career Suite.',
            ],
          ),
          const _HelpSection(
            icon: Icons.lock_outline,
            title: 'Sécurité locale',
            items: [
              "L'application fonctionne hors ligne, sans compte et sans Firebase.",
              'Les réglages permettent de préparer PIN, mot de passe, verrouillage automatique et confirmation avant suppression.',
              'La corbeille permet de restaurer les rapports supprimés avant effacement définitif.',
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpSection extends StatelessWidget {
  const _HelpSection({
    required this.icon,
    required this.title,
    required this.items,
  });

  final IconData icon;
  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: theme.colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
