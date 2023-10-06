import 'package:flutter/material.dart';
import 'package:sync_launcher/database/sqlite_handler.dart';

class BaseRepository {
  @protected
  final SqliteHandler sqliteHandler = SqliteHandler();
}