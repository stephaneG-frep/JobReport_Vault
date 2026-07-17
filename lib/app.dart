import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/settings.dart';
import 'providers/settings_provider.dart';
import 'screens/activities_screen.dart';
import 'screens/backup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/documents_screen.dart';
import 'screens/export_screen.dart';
import 'screens/help_screen.dart';
import 'screens/proofs_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/statistics_screen.dart';

class JobReportVaultApp extends StatelessWidget {
  const JobReportVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>().settings;
    final seed = const Color(0xFF0B5D3B);
    final darkTheme = settings.themeChoice == VaultThemeChoice.deepForest
        ? _deepForestTheme(seed)
        : _greenNightTheme(seed);
    return MaterialApp(
      title: 'JobReport Vault',
      debugShowCheckedModeBanner: false,
      themeMode: settings.themeChoice == VaultThemeChoice.light
          ? ThemeMode.light
          : ThemeMode.dark,
      theme: _lightGreenTheme(seed),
      darkTheme: darkTheme,
      home: const VaultShell(),
    );
  }

  ThemeData _lightGreenTheme(Color seed) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      primary: const Color(0xFF0B5D3B),
      secondary: const Color(0xFF1F6F4A),
      tertiary: const Color(0xFFB26A00),
      surface: const Color(0xFFF6FAF7),
      surfaceContainerHighest: const Color(0xFFDDE9E1),
    ),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.all(6)),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: const Color(0xFF0B5D3B).withValues(alpha: 0.16),
    ),
  );

  ThemeData _greenNightTheme(Color seed) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      primary: const Color(0xFF7DD8A6),
      secondary: const Color(0xFF5CBF8A),
      tertiary: const Color(0xFFFFB454),
      surface: const Color(0xFF07140E),
      surfaceContainerLowest: const Color(0xFF05100B),
      surfaceContainer: const Color(0xFF0D1D15),
      surfaceContainerHighest: const Color(0xFF1A3024),
    ),
    scaffoldBackgroundColor: const Color(0xFF07140E),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF07140E),
      foregroundColor: Color(0xFFE3F3E9),
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.all(6)),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Color(0xFF07140E),
      indicatorColor: Color(0xFF163D2A),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF0D1D15),
      indicatorColor: Color(0xFF1B5137),
    ),
  );

  ThemeData _deepForestTheme(Color seed) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      primary: const Color(0xFF9BE7B8),
      secondary: const Color(0xFF2E8B57),
      tertiary: const Color(0xFFD39B36),
      surface: const Color(0xFF020A06),
      surfaceContainerLowest: const Color(0xFF000604),
      surfaceContainer: const Color(0xFF06130C),
      surfaceContainerHighest: const Color(0xFF102619),
    ),
    scaffoldBackgroundColor: const Color(0xFF020A06),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF020A06),
      foregroundColor: Color(0xFFE8F7EC),
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.all(6),
      color: Color(0xFF06130C),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Color(0xFF020A06),
      indicatorColor: Color(0xFF0E3A22),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xFF06130C),
      indicatorColor: Color(0xFF124C2D),
    ),
  );
}

class VaultShell extends StatefulWidget {
  const VaultShell({super.key});

  @override
  State<VaultShell> createState() => _VaultShellState();
}

class _VaultShellState extends State<VaultShell> {
  var _index = 0;
  static const _mobileIndexes = [0, 1, 5, 8, 9];

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
    const HelpScreen(),
  ];

  static const _destinations = [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Accueil',
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
    NavigationDestination(
      icon: Icon(Icons.help_outline),
      selectedIcon: Icon(Icons.help),
      label: 'Aide',
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
            selectedIndex: _mobileIndexes.contains(_index)
                ? _mobileIndexes.indexOf(_index)
                : 0,
            labelBehavior:
                NavigationDestinationLabelBehavior.onlyShowSelected,
            onDestinationSelected: (value) =>
                setState(() => _index = _mobileIndexes[value]),
            destinations: _mobileIndexes
                .map((index) => _destinations[index])
                .toList(),
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
