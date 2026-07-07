import 'package:flutter/foundation.dart';

import '../models/settings.dart';
import '../services/database_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider(this._databaseService);

  final DatabaseService _databaseService;
  VaultSettings _settings = const VaultSettings();

  VaultSettings get settings => _settings;

  Future<void> load() async {
    _settings = _databaseService.getSettings();
    notifyListeners();
  }

  Future<void> update(VaultSettings settings) async {
    _settings = settings;
    await _databaseService.saveSettings(settings);
    notifyListeners();
  }

  Future<void> markExported() =>
      update(_settings.copyWith(lastExportAt: DateTime.now()));
}
