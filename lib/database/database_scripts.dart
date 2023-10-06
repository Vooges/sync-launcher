class DatabaseScripts {
  static const String create = '''
    CREATE TABLE launchers (
      id INTEGER PRIMARY KEY,
      value TEXT NOT NULL,
      image_path TEXT NOT NULL
    );

    CREATE TABLE games (
      id INTEGER PRIMARY KEY,
      app_id TEXT NOT NULL,
      title TEXT NOT NULL,
      launch_url TEXT NOT NULL,
      launcher_id INTEGER NOT NULL,
      image_path TEXT,
      description TEXT DEFAULT 'Unknown',
      install_size INTEGER DEFAULT 0,
      version TEXT DEFAULT 'Unknown',

      FOREIGN KEY (launcher_id) REFERENCES launchers(id)
    );

    CREATE TABLE dlc (
      id INTEGER PRIMARY KEY,
      app_id TEXT NOT NULL,
      title TEXT NOT NULL,
      parent_id INTEGER NOT NULL,
      parent_app_id TEXT NOT NULL,
      image_path TEXT,
      install_size INTEGER DEFAULT 0,

      FOREIGN KEY (parent_id) REFERENCES games(id)
    );

    CREATE TABLE users (
      id INTEGER PRIMARY KEY,
      unique_launcher_identifier STRING NOT NULL,
      launcher_id INTEGER NOT NULL,

      FOREIGN KEY (launcher_id) REFERENCES launchers(id)
    );

    CREATE TABLE sessions (
      id INTEGER PRIMARY KEY,
      game_id INTEGER NOT NULL,
      start_time INTEGER NOT NULL,
      end_time INTEGER NOT NULL,

      FOREIGN KEY (game_id) REFERENCES games(id)
    );
  ''';
}