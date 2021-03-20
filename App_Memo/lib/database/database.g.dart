// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MemoDAO _memoDAOInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Memo` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT, `body` TEXT, `tag` TEXT, `status` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MemoDAO get memoDAO {
    return _memoDAOInstance ??= _$MemoDAO(database, changeListener);
  }
}

class _$MemoDAO extends MemoDAO {
  _$MemoDAO(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _memoInsertionAdapter = InsertionAdapter(
            database,
            'Memo',
            (Memo item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'tag': item.tag,
                  'status': item.status
                },
            changeListener),
        _memoUpdateAdapter = UpdateAdapter(
            database,
            'Memo',
            ['id'],
            (Memo item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'tag': item.tag,
                  'status': item.status
                },
            changeListener),
        _memoDeletionAdapter = DeletionAdapter(
            database,
            'Memo',
            ['id'],
            (Memo item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'tag': item.tag,
                  'status': item.status
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Memo> _memoInsertionAdapter;

  final UpdateAdapter<Memo> _memoUpdateAdapter;

  final DeletionAdapter<Memo> _memoDeletionAdapter;

  @override
  Stream<List<Memo>> getAllMemo() {
    return _queryAdapter.queryListStream('SELECT * from Memo',
        queryableName: 'Memo',
        isView: false,
        mapper: (Map<String, dynamic> row) => Memo(
            id: row['id'] as int,
            title: row['title'] as String,
            body: row['body'] as String,
            tag: row['tag'] as String,
            status: row['status'] as String));
  }

  @override
  Stream<Memo> getMemoById(int id) {
    return _queryAdapter.queryStream('SELECT * from Memo WHERE id=?',
        arguments: <dynamic>[id],
        queryableName: 'Memo',
        isView: false,
        mapper: (Map<String, dynamic> row) => Memo(
            id: row['id'] as int,
            title: row['title'] as String,
            body: row['body'] as String,
            tag: row['tag'] as String,
            status: row['status'] as String));
  }

  @override
  Future<void> deleteAllMemo() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Memo');
  }

  @override
  Future<void> newMemo(Memo memo) async {
    await _memoInsertionAdapter.insert(memo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMemo(Memo memo) async {
    await _memoUpdateAdapter.update(memo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMemo(Memo memo) async {
    await _memoDeletionAdapter.delete(memo);
  }
}
