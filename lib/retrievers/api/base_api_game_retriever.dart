import 'package:sync_launcher/retrievers/retrieve_games.dart';

abstract class BaseAPIGameRetriever implements RetrieveGames {
  String? userId;

  BaseAPIGameRetriever({this.userId});
}