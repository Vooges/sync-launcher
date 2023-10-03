import 'package:sync_launcher/models/game_info.dart';

abstract class BaseGameRetriever {
  String manifestLocation;

  BaseGameRetriever({required this.manifestLocation});

  /// Gets the locally installed games.
  Future<List<GameInfo>> retrieve();
}