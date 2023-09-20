import 'package:sync_launcher/models/game_info.dart';

abstract class BaseLocalGameRetriever {
  String manifestLocation;

  BaseLocalGameRetriever({required this.manifestLocation});

  /// Gets the locally installed games.
  Future<List<GameInfo>> retrieve();
}