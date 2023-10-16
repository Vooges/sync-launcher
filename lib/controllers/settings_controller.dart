import 'package:sync_launcher/database/repositories/launcher_repository.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/api/steam/api_steam_retriever.dart';
import 'package:sync_launcher/retrievers/game_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';

class SettingsController {
  final LauncherRepository _launcherRepository = LauncherRepository();

  Future<void> setLauncherInstallPath({required int launcherId, String? installPath}) async {
    await _launcherRepository.setInstallPath(id: launcherId, installPath: installPath);
  }

  Future<List<LauncherInfo>> getLaunchers() async {
    return await _launcherRepository.getLaunchers();
  }

  Future<void> runGameRetriever({required int launcherId}) async {
    LauncherInfo? launcher = await _launcherRepository.getLauncherById(id: launcherId);

    if (launcher == null){
      throw Exception('Could not find launcher.');
    }

    late GameRetriever gameRetriever;
    
    switch (launcher.title) {
      case 'Steam':
        String? localPath = launcher.installPath;

        if (localPath != null) {
          gameRetriever = GameRetriever(
            apiRetriever: APISteamRetriever(userId: '76561198440106475'), // TODO: remove this hardcoded userId and use the actual user's userId.
            localRetriever: LocalSteamRetriever(
              launcherBasePath: localPath,
            ),
          );
        }
        break;
      case 'Epic Games':
        String? localPath = launcher.installPath;

        if (localPath != null) {
          gameRetriever = GameRetriever(
            localRetriever: LocalEpicGamesRetriever(
              launcherBasePath: localPath,
            ),
          );
        }

        break;
    }
      gameRetriever.retrieveGames();
  }
}