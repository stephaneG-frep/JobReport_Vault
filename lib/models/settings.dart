enum VaultThemeChoice {
  light,
  greenNight,
  deepForest;

  String get label => switch (this) {
    VaultThemeChoice.light => 'Clair vert',
    VaultThemeChoice.greenNight => 'Vert nuit',
    VaultThemeChoice.deepForest => 'Forêt profonde',
  };
}

class VaultSettings {
  const VaultSettings({
    this.darkMode = false,
    this.themeChoice = VaultThemeChoice.light,
    this.pinEnabled = false,
    this.passwordEnabled = false,
    this.localEncryption = true,
    this.autoLockMinutes = 10,
    this.confirmBeforeDelete = true,
    this.lastExportAt,
    this.authorName = 'Utilisateur',
  });

  final bool darkMode;
  final VaultThemeChoice themeChoice;
  final bool pinEnabled;
  final bool passwordEnabled;
  final bool localEncryption;
  final int autoLockMinutes;
  final bool confirmBeforeDelete;
  final DateTime? lastExportAt;
  final String authorName;

  Map<String, dynamic> toJson() => {
    'darkMode': darkMode,
    'themeChoice': themeChoice.name,
    'pinEnabled': pinEnabled,
    'passwordEnabled': passwordEnabled,
    'localEncryption': localEncryption,
    'autoLockMinutes': autoLockMinutes,
    'confirmBeforeDelete': confirmBeforeDelete,
    'lastExportAt': lastExportAt?.toIso8601String(),
    'authorName': authorName,
  };

  factory VaultSettings.fromJson(Map<String, dynamic> json) => VaultSettings(
    darkMode: json['darkMode'] as bool? ?? false,
    themeChoice: _themeChoiceFromJson(json),
    pinEnabled: json['pinEnabled'] as bool? ?? false,
    passwordEnabled: json['passwordEnabled'] as bool? ?? false,
    localEncryption: json['localEncryption'] as bool? ?? true,
    autoLockMinutes: json['autoLockMinutes'] as int? ?? 10,
    confirmBeforeDelete: json['confirmBeforeDelete'] as bool? ?? true,
    lastExportAt: json['lastExportAt'] == null
        ? null
        : DateTime.parse(json['lastExportAt'] as String),
    authorName: json['authorName'] as String? ?? 'Utilisateur',
  );

  VaultSettings copyWith({
    bool? darkMode,
    VaultThemeChoice? themeChoice,
    bool? pinEnabled,
    bool? passwordEnabled,
    bool? localEncryption,
    int? autoLockMinutes,
    bool? confirmBeforeDelete,
    DateTime? lastExportAt,
    String? authorName,
  }) => VaultSettings(
    darkMode: darkMode ?? this.darkMode,
    themeChoice: themeChoice ?? this.themeChoice,
    pinEnabled: pinEnabled ?? this.pinEnabled,
    passwordEnabled: passwordEnabled ?? this.passwordEnabled,
    localEncryption: localEncryption ?? this.localEncryption,
    autoLockMinutes: autoLockMinutes ?? this.autoLockMinutes,
    confirmBeforeDelete: confirmBeforeDelete ?? this.confirmBeforeDelete,
    lastExportAt: lastExportAt ?? this.lastExportAt,
    authorName: authorName ?? this.authorName,
  );

  static VaultThemeChoice _themeChoiceFromJson(Map<String, dynamic> json) {
    final stored = json['themeChoice'] as String?;
    if (stored != null) {
      return VaultThemeChoice.values.byName(stored);
    }
    return (json['darkMode'] as bool? ?? false)
        ? VaultThemeChoice.greenNight
        : VaultThemeChoice.light;
  }
}
