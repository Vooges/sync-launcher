import 'package:sync_launcher/retrievers/interfaces/retrieve_games.dart';

abstract class BaseLocalGameRetriever implements RetrieveGames {
  String manifestLocation;

  BaseLocalGameRetriever({required this.manifestLocation});
}