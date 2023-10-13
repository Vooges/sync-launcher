import 'package:flutter/foundation.dart';

class SettingsState {
  late bool darkTheme;
  late String? steamBasePath;
  late String? epicBasePath;

  SettingsState() {
    darkTheme = true;
    steamBasePath = _getSteamBasePath();
    epicBasePath = _getEpicBasePath();
  }

  String? _getSteamBasePath() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return "C:\\Program Files (x86)\\Steam";
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      return "~/.steam/steam/";
    }

    return null;
  }

  String? _getEpicBasePath() {
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return "C:\\ProgramData\\Epic\\EpicGamesLauncher\\Data\\Manifests";
    }

    return null;
  }
}
