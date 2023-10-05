class DatabaseScripts {
  static const String create = '''
    CREATE TABLE launchers (
      id INTEGER PRIMARY KEY,
      value TEXT NOT NULL
    );

    CREATE TABLE games (
      id INTEGER PRIMARY KEY,
      app_id TEXT NOT NULL,
      title TEXT NOT NULL,
      launch_url TEXT NOT NULL,
      launcher_id INTEGER NOT NULL,
      image_path TEXT,
      description TEXT,
      install_size INTEGER,
      version TEXT,

      FOREIGN KEY (launcher_id) REFERENCES launchers(id)
    );

    CREATE TABLE dlc (
      id INTEGER PRIMARY KEY,
      app_id TEXT NOT NULL,
      title TEXT NOT NULL,
      parent_id INTEGER NOT NULL,
      image_path TEXT,
      install_size INTEGER,

      FOREIGN KEY (parent_id) REFERENCES games(id)
    );
  ''';
}