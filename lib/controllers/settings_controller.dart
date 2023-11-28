import 'package:sync_launcher/database/repositories/account_value_repository.dart';
import 'package:sync_launcher/database/repositories/launcher_repository.dart';
import 'package:sync_launcher/models/account_value.dart';
import 'package:sync_launcher/models/launcher_info.dart';
import 'package:sync_launcher/retrievers/api/steam/api_steam_retriever.dart';
import 'package:sync_launcher/retrievers/game_retriever.dart';
import 'package:sync_launcher/retrievers/local/epic_games/local_epic_games_retriever.dart';
import 'package:sync_launcher/retrievers/local/steam/local_steam_retriever.dart';
import 'package:sync_launcher/retrievers/local/ubisoft_connect/local_ubisoft_connect_retriever.dart';
import 'package:sync_launcher/retrievers/metadata/steam/local_steam_metadata_retriever.dart';

class SettingsController {
  final LauncherRepository _launcherRepository = LauncherRepository();
  final AccountValueRepository _accountValueRepository = AccountValueRepository();

  Future<void> setLauncherInstallPath({required int launcherId, String? installPath}) async {
    await _launcherRepository.setInstallPath(id: launcherId, installPath: installPath);
  }

  Future<List<LauncherInfo>> getLaunchers() async {
    return await _launcherRepository.getLaunchers();
  }

  Future<LauncherInfo?> getLauncher({required int id}) async {
    return await _launcherRepository.getLauncherById(id: id);
  }

  Future<List<AccountValue>> getLauncherAccountValues({required int id}) async {
    return await _accountValueRepository.getAccountValuesForLauncher(launcherId: id);
  }

  Future<void> updateAccountValueForLauncher({required AccountValue value}) async {
    await _accountValueRepository.updateAccountValueForLauncher(accountValue: value);
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
          String? steam64Id = (await _accountValueRepository.getAccountValueByNameForLauncher(name: 'steam64Id', launcherId: launcherId))?.value;
          String? steam32Id = (await _accountValueRepository.getAccountValueByNameForLauncher(name: 'steam32Id', launcherId: launcherId))?.value;

          if (steam32Id != null){
            APISteamRetriever? apiSteamRetriever = (steam64Id != null) 
            ? APISteamRetriever(
                userId: steam64Id,
                metadataRetriever: LocalSteamMetadataRetriever(steamBasePath: localPath, steam32Id: steam32Id)
            )
            : null;

            gameRetriever = GameRetriever(
              apiRetriever: apiSteamRetriever,
              localRetriever: LocalSteamRetriever(
                launcherBasePath: localPath,
                steam32Id: steam32Id
              ),
            );
          } else {
            // TODO: Show error 'Steam32Id has to be filled in'.
          }
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
      case 'Ubisoft Connect':
        String? localPath = launcher.installPath;

        if (localPath != null){
          gameRetriever = GameRetriever(
            localRetriever: LocalUbisoftConnectRetriever(
              launcherBasePath: localPath
            )
          );
        }

        break;
    }
      
    gameRetriever.retrieveGames();
  }
}