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

    CREATE TABLE sessions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      game_id INTEGER NOT NULL,
      start_time INTEGER NOT NULL,
      end_time INTEGER NOT NULL,

      FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE
    );

    CREATE TABLE account_values (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      launcher_id INTEGER NOT NULL,
      value TEXT,
      name TEXT NOT NULL,

      FOREIGN KEY (launcher_id) REFERENCES launchers(id) ON DELETE CASCADE
    );

    CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      value TEXT NOT NULL
    );

    CREATE TABLE game_categories (
      game_id INTEGER NOT NULL,
      category_id INTEGER NOT NULL,

      PRIMARY KEY (game_id, category_id),
      FOREIGN KEY (game_id) REFERENCES games(id) ON DELETE CASCADE,
      FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
    );
  ''';

  static const String insertLaunchers = '''
    INSERT INTO launchers VALUES
      (1, 'Steam', 'assets/images/launchers/steam/logo.png', NULL),
      (2, 'Epic Games', 'assets/images/launchers/epic_games/logo.png', NULL),
      (3, 'Ubisoft Connect', 'assets/images/launchers/ubisoft_connect/logo.png', NULL);
  ''';

  // TODO: magic value '1' *should* be retrieved from the database.
  static const String insertAccountValues = '''
    INSERT INTO account_values VALUES 
      (NULL, 1, NULL, 'steamId'),
      (NULL, 1, NULL, 'steam32Id'),
      (NULL, 1, NULL, 'steam64Id')
  ''';
}