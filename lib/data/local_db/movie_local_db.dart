import 'package:movie_mania/core/utilities/imports.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class MovieLocalDb {
  static final MovieLocalDb _instance = MovieLocalDb._internal();

  factory MovieLocalDb() => _instance;

  MovieLocalDb._internal();

  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'movies.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE movies (
            id INTEGER PRIMARY KEY,
            title TEXT,
            posterPath TEXT,
            overview TEXT,
            genres TEXT,
            releaseDate TEXT,
            isTrending INTEGER,
            isNowPlaying INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE movie_details (
            id INTEGER PRIMARY KEY,
            title TEXT,
            overview TEXT,
            release_date TEXT,
            genres TEXT,
            backdrop_path TEXT,
            poster_path TEXT,
            runtime INTEGER,
            vote_average REAL,
            number_of_seasons INTEGER
          )
        ''');

        await db.execute('''
          CREATE TABLE videos (
            id TEXT PRIMARY KEY,
            movie_id INTEGER,
            key TEXT,
            name TEXT,
            site TEXT,
            type TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE cast_members (
            id INTEGER PRIMARY KEY,
            movie_id INTEGER,
            name TEXT,
            profile_path TEXT,
            character TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertMovies(List<Movie> movies,
      {bool isTrending = false, bool isNowPlaying = false}) async {
    final db = await database;
    for (var movie in movies) {
      await db.insert(
        'movies',
        {
          'id': movie.id,
          'title': movie.title,
          'posterPath': movie.posterPath,
          // 'overview': movie.overview ?? '',
          // 'genres': movie.genres?.join(',') ?? '',
          // 'releaseDate': movie.releaseDate ?? '',
          'isTrending': isTrending ? 1 : 0,
          'isNowPlaying': isNowPlaying ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Movie>> fetchMovies({bool trending = false, bool nowPlaying = false}) async {
    final db = await database;
    final results = await db.query(
      'movies',
      where: trending
          ? 'isTrending = 1'
          : nowPlaying
              ? 'isNowPlaying = 1'
              : null,
    );
    return results.map((e) => Movie.fromMap(e)).toList();
  }

  /// Insert movie details from movie details page
  static Future<void> insertMovieDetail(MovieDetail detail) async {
    final db = await database;
    await db.insert(
      'movie_details',
      detail.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<MovieDetail?> fetchMovieDetail(int id) async {
    final db = await database;
    final maps = await db.query(
      'movie_details',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return MovieDetail.fromJson(maps.first);
    }
    return null;
  }

  /// Insert videos
  static Future<void> insertVideos(List<Video> videos, int movieId) async {
    final db = await database;
    for (var video in videos) {
      await db.insert(
        'videos',
        {...video.toJson(), 'movie_id': movieId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Video>> getVideos(int movieId) async {
    final db = await database;
    final result = await db.query(
      'videos',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
    return result.map((e) => Video.fromJson(e)).toList();
  }

  /// Insert cast
  static Future<void> insertCast(List<CastMember> cast, int movieId) async {
    final db = await database;
    for (var member in cast) {
      await db.insert(
        'cast_members',
        {...member.toJson(), 'movie_id': movieId},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<CastMember>> getCast(int movieId) async {
    final db = await database;
    final result = await db.query(
      'cast_members',
      where: 'movie_id = ?',
      whereArgs: [movieId],
    );
    return result.map((e) => CastMember.fromJson(e)).toList();
  }
}
