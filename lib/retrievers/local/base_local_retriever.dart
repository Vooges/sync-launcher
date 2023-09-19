import 'package:sync_launcher/models/game_info.dart';

abstract class BaseLocalRetriever {
  String manifestLocation;

  BaseLocalRetriever(this.manifestLocation);

  Future<List<GameInfo>> retrieve();
}