import 'dart:convert';
import 'dart:io';

import 'package:sync_launcher/models/dlc_info.dart';
import 'package:sync_launcher/models/game_info.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/local/base_local_game_retriever.dart';
import 'package:yaml/yaml.dart';

class LocalUbisoftConnectRetriever extends BaseLocalGameRetriever{
  LocalUbisoftConnectRetriever({required super.launcherBasePath});

  @override
  Future<List<GameInfo>> retrieve() async {
    // Step 1: Read the file contents.
    final Directory manifestDirectory = Directory('${super.launcherBasePath}\\cache\\configuration');
    File manifest = await manifestDirectory.list().first as File;
    const codec = Utf8Codec(allowMalformed: true);
    final List<int> bytes = List.from(await manifest.readAsBytes());
    bytes.removeRange(0, 27); // This removes some problematic characters, it actually converts to a string thanks to this.
    final String fileContents = codec.decode(bytes);

    // Step 2: Remove non-ASCII characters
    // * This removes basically all of the russian characters aswell. Not exactly what I wanted but it'll do for now.
    String cleanedContents = fileContents.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');

    // Step 3: Separate the items.
    List<String> items = cleanedContents.split(RegExp(r'version: [0-9]+.[0-9]+'));
    List<String> toAdd = [];

    for (String item in items) {
      List<String> temp = item.split('localizations: {}\r\n');

      items[items.indexOf(item)] = temp[0];

      if (temp.length > 1 && temp[1].isNotEmpty){
        toAdd.add(temp[1]);
      }
    }

    items.addAll(toAdd);

    items.removeWhere((element) => !element.contains('root'));

    // Step 4: Handle item types.
    List<GameInfo> foundGames = [];
    List<DLCInfo> foundDLC = [];

    for (String item in items){
      // Turns out there is a lot of work that needs to be done to make the data usable. 
      String specialCharactersRemoved = item.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]+'), '');
      String commentsRemoved = specialCharactersRemoved.replaceAll(RegExp(r'#.*\n'), '');
      String upnEnabledRemoved = commentsRemoved.replaceAll(RegExp(r'upn_enabled: \b(?:true|false)\b'), '');
      String lastPeriodRemoved = (upnEnabledRemoved.endsWith('.')) ? upnEnabledRemoved.substring(0, upnEnabledRemoved.length - 1): upnEnabledRemoved;
      String invalidLocalizationsRemoved = lastPeriodRemoved.replaceAll(RegExp(r'\s*([l\d+]|\w+):\s*-\s*\r\n'), '\r\n');
      String caretsRemoved = invalidLocalizationsRemoved.replaceAll(RegExp(r'\^(?![^\n]*:)|(?<=:|^)\^'), '');

      String invalidYamlRemoved = caretsRemoved.replaceAll(RegExp(r'^((?!(\s*)(?:-\s*)?([\w]+|[\w]+-[\w]+):)).*', multiLine: true), '');

      dynamic yaml = loadYaml(invalidYamlRemoved);

      if (yaml['root']['start_game'] != null){
        foundGames.add(_buildGame(yaml: yaml));
      } else if (yaml['root']['is_ulc'] == null){
        foundDLC.add(_buildDLC(yaml: yaml));
      }
    }

    // Step 5: Match DLC to Games.
    return _matchDLC(games: foundGames, dlcs: foundDLC);
  }

  GameInfo _buildGame({required dynamic yaml}){
    // Some assets are in C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\cache\assets, mostly grid images but for 
    // whatever reason the hero image for Rayman Legends is here aswell. 
    // * These assets are incredibly low res (240 x 280)
    // Icons are in C:\Program Files (x86)\Ubisoft\Ubisoft Game Launcher\data\games
    
    dynamic root = yaml['root'];
    String appId = 'appId'; // TODO: Find this.

    return GameInfo(
      title: _handleName(yaml: yaml), 
      appId: appId, 
      // iconImagePath: 'basePath/${yaml['icon_image']}',
      // heroImagePath: 'basePath/${yaml['background_image']}', // * These must be somewhere, haven't found them though.
      gridImagePath: '${super.launcherBasePath}/cache/assets/${root['thumb_image']}',
      description: null,
      installSize: 0,
      version: 'Unknown',
      launchURL: 'uplay://launch/$appId/0', 
      launcherInfo: LauncherInfo(
        title: 'Ubisoft Connect',
        imagePath: 'assets/images/launchers/ubisoft_connect/logo.svg'
      )
    );
  }

  DLCInfo _buildDLC({required dynamic yaml}){
    dynamic root = yaml['root'];
    String appId = 'appId'; // TODO: Find this.

    return DLCInfo(
      title: (root['name'] ?? 'Unknown DLC') as String, 
      appId: appId, 
      parentAppId: 'parentAppId',
      // imagePath: 'basePath/${yaml['thumb_image']}', // * Haven't found this one yet either.
      installSize: 0
    );
  }

  List<GameInfo> _matchDLC({required List<GameInfo> games, required List<DLCInfo> dlcs}){
    games.removeWhere((element) => element.title == 'Unknown Game');
    dlcs.removeWhere((element) => element.title == 'Unknown DLC');

    for (GameInfo game in games){
      // * This works accurately enough.
      game.dlc = dlcs.where((element) => element.title.startsWith(game.title)).toList();
    }

    return games;
  }

  String _handleName({required dynamic yaml}){
    String? name = yaml['root']['name'];

    if (name == null){
      return 'Unknown Game';
    }
    
    dynamic localizations = yaml['localizations'];

    RegExp regex = RegExp(r'');

    if (regex.hasMatch(name) && localizations != null){
      // Get the name from the localizations.
      String? localizedName = localizations['default'][name];

      if (localizedName != null && localizedName.isNotEmpty){
        return localizedName;
      }
    }

    return name;
  }
}
