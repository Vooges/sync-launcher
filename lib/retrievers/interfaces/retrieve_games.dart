import 'package:sync_launcher/models/game_info.dart';

abstract class RetrieveGames {
  /// Gets the locally installed games.
  Future<List<GameInfo>> retrieve();
}