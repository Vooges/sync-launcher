import 'package:sync_launcher/models/game_info.dart';

abstract class BaseLocalGameRetriever {
  String manifestLocation;

  BaseLocalGameRetriever(this.manifestLocation);

  Future<List<GameInfo>> retrieve();
}