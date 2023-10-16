class DatabaseScripts {
  static const String create = '''
    CREATE TABLE launchers (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      image_path TEXT NOT NULL,
      install_path TEXT
    );

    CREATE TABLE games (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      app_id TEXT NOT NULL,
      title TEXT NOT NULL,
      launch_url TEXT NOT NULL,
      launcher_id INTEGER NOT NULL,
      icon_image_path TEXT,
      grid_image_path TEXT,
      hero_image_path TEXT,
      description TEXT,
      install_size INTEGER DEFAULT 0,
      version TEXT,

      FOREIGN KEY (launcher_id) REFERENCES launchers(id) ON DELETE CASCADE
    );

    CREATE TABLE dlc (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      app_id TEXT NOT NULL,
      title TEXT NOT NULL,
      parent_id INTEGER NOT NULL,
      parent_app_id TEXT NOT NULL,
      image_path TEXT,
      install_size INTEGER DEFAULT 0,

      FOREIGN KEY (parent_id) REFERENCES games(id) ON DELETE CASCADE
    );

    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unique_launcher_identifier STRING NOT NULL,
      launcher_id INTEGER NOT NULL,

      FOREIGN KEY (launcher_id) REFERENCES launchers(id) ON DELETE CASCADE
    );

    CREATE TABLE sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      game_id INTEGER NOT NULL,
      start_time INTEGER NOT NULL,
      end_time INTEGER NOT NULL,

      FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
    );
  ''';

  static const String insertLaunchers = '''
    INSERT INTO launchers VALUES
      (NULL, 'Steam', 'lib/assets/images/launchers/steam/logo.svg', NULL),
      (NULL, 'Epic Games', 'lib/assets/images/launchers/epic_games/logo.svg', NULL);
  ''';
}