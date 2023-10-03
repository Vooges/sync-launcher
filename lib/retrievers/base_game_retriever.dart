import 'package:sync_launcher/models/game_info.dart';

abstract class BaseGameRetriever {
  String? userId;
  String? manifestLocation;

  BaseGameRetriever({this.manifestLocation, this.userId});

  /// Gets the locally installed games.
  Future<List<GameInfo>> retrieve();
}