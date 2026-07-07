import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'screens/activities_screen.dart';
import 'screens/backup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/export_screen.dart';
import 'screens/proofs_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';

class JobReportVaultApp extends StatelessWidget {
  const JobReportVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    final darkMode = context.watch<SettingsProvider>().settings.darkMode;
    final seed = const Color(0xFF1565C0);
    return MaterialApp(
      title: 'JobReport Vault',
      debugShowCheckedModeBanner: false,
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.light,
          secondary: const Color(0xFF2E7D32),
          tertiary: const Color(0xFFF57C00),
        ),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.all(6)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          secondary: const Color(0xFF66BB6A),
          tertiary: const Color(0xFFFFB74D),
        ),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.all(6)),
      ),
      home: const VaultShell(),
    );
  }
}

class VaultShell extends StatefulWidget {
  const VaultShell({super.key});

  @override
  State<VaultShell> createState() => _VaultShellState();
}

class _VaultShellState extends State<VaultShell> {
  var _index = 0;

  static final _screens = [
    const DashboardScreen(),
    const ReportsScreen(),
    const ActivitiesScreen(),
    const DocumentsScreen(),
    const ProofsScreen(),
    const StatisticsScreen(),
    const ExportScreen(),
    const BackupScreen(),
    const SettingsScreen(),
  ];

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(Icons.article_outlined),
      selectedIcon: Icon(Icons.article),
      label: 'Rapports',
    ),
    NavigationDestination(
      icon: Icon(Icons.task_alt_outlined),
      selectedIcon: Icon(Icons.task_alt),
      label: 'Activités',
    ),
    NavigationDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder),
      label: 'Documents',
    ),
    NavigationDestination(
      icon: Icon(Icons.verified_outlined),
      selectedIcon: Icon(Icons.verified),
      label: 'Preuves',
    ),
    NavigationDestination(
      icon: Icon(Icons.bar_chart_outlined),
      selectedIcon: Icon(Icons.bar_chart),
      label: 'Stats',
    ),
    NavigationDestination(
      icon: Icon(Icons.ios_share_outlined),
      selectedIcon: Icon(Icons.ios_share),
      label: 'Export',
    ),
    NavigationDestination(
      icon: Icon(Icons.backup_outlined),
      selectedIcon: Icon(Icons.backup),
      label: 'Sauvegarde',
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: 'Réglages',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        if (wide) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _index,
                  extended: constraints.maxWidth >= 1200,
                  onDestinationSelected: (value) =>
                      setState(() => _index = value),
                  destinations: _destinations
                      .map(
                        (item) => NavigationRailDestination(
                          icon: item.icon,
                          selectedIcon: item.selectedIcon,
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: _screens[_index]),
              ],
            ),
          );
        }
        return Scaffold(
          body: _screens[_index],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: _destinations.take(5).toList(),
          ),
          drawer: NavigationDrawer(
            selectedIndex: _index,
            onDestinationSelected: (value) {
              Navigator.pop(context);
              setState(() => _index = value);
            },
            children: [
              const DrawerHeader(child: Text('JobReport Vault')),
              ..._destinations.asMap().entries.map(
                (entry) => NavigationDrawerDestination(
                  icon: entry.value.icon,
                  selectedIcon: entry.value.selectedIcon,
                  label: Text(entry.value.label),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
