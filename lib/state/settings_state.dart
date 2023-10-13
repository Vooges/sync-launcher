import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

class SettingsState {
  late String? steamBasePath;
  late String? epicBasePath;

  SettingsState() {
    steamBasePath = _getSteamBasePath();
    epicBasePath = _getEpicBasePath();

    _init();
  }

  save() async {
    final box = Hive.box('settings_state');

    await box.put('steamBasePath', steamBasePath);
    await box.put('epicBasePath', epicBasePath);
  }

  _init() async {
    await Hive.openBox('settings_state', path: './');
    final box = Hive.box('settings_state');

    steamBasePath = await box.get('steamBasePath') ?? steamBasePath;
    epicBasePath = await box.get('epicBasePath') ?? epicBasePath;
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
