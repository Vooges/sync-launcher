import 'package:sync_launcher/models/reduced_game_info.dart';
import 'package:sync_launcher/models/sync_user.dart';

class FriendsPlaying {
  final SyncUser user;
  final ReducedGameInfo gameInfo;

  FriendsPlaying({required this.user, required this.gameInfo});
}
