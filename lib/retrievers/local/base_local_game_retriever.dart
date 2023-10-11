import 'package:sync_launcher/retrievers/interfaces/retrieve_games.dart';

abstract class BaseLocalGameRetriever implements RetrieveGames {
  String steamBasePath;

  BaseLocalGameRetriever({required this.steamBasePath});
}