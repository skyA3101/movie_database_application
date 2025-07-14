import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/movie_detail.dart';

class BookmarkLocalDb {
  static final BookmarkLocalDb _instance = BookmarkLocalDb._internal();

  factory BookmarkLocalDb() => _instance;

  BookmarkLocalDb._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'bookmarks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE bookmarks (
            id INTEGER PRIMARY KEY,
            title TEXT,
            poster_path TEXT,
            overview TEXT,
            release_date TEXT,
            runtime INTEGER,
            number_of_seasons INTEGER,
            genres TEXT,
            genre_ids TEXT
          )
        ''');
      },
    );
  }

  Future<void> insert(MovieDetail movie) async {
    final database = await db;
    await database.insert(
      'bookmarks',
      movie.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(int id) async {
    final database = await db;
    await database.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<MovieDetail>> fetchAll() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('bookmarks');
    return maps.map((map) => MovieDetail.fromJson(map)).toList();
  }

  Future<bool> isBookmarked(int id) async {
    final database = await db;
    final maps = await database.query('bookmarks', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }
}
