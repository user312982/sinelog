import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/movie.dart';
import 'movie_local_datasource.dart';

const _databaseName = 'sinelog.db';
const _table = 'movies';

class SqfliteMovieDatasource implements MovieLocalDatasource {
  static Database? _database;

  /// Dibuka sekali lalu dipakai ulang — membuka database berkali-kali mahal.
  Future<Database> get _db async => _database ??= await _openDatabase();

  Future<Database> _openDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) => db.execute('''
        CREATE TABLE $_table(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          tmdbId INTEGER UNIQUE NOT NULL,
          title TEXT NOT NULL,
          posterPath TEXT,
          overview TEXT NOT NULL,
          releaseDate TEXT NOT NULL,
          watchedStatus TEXT NOT NULL DEFAULT '${Movie.unwatched}',
          rating INTEGER
        )
      '''),
    );
  }

  @override
  Future<List<Movie>> getAll() async {
    final db = await _db;
    final rows = await db.query(_table, orderBy: 'id DESC');
    return rows.map(Movie.fromMap).toList();
  }

  @override
  Future<Movie?> getById(int id) => _findOne('id = ?', [id]);

  @override
  Future<Movie?> getByTmdbId(int tmdbId) => _findOne('tmdbId = ?', [tmdbId]);

  @override
  Future<bool> exists(int tmdbId) async => await getByTmdbId(tmdbId) != null;

  @override
  Future<void> insert(Movie movie) async {
    final db = await _db;
    // id dibuang supaya SQLite yang memberi nomor lewat AUTOINCREMENT.
    final values = movie.toMap()..remove('id');
    await db.insert(_table, values, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  @override
  Future<void> update(Movie movie) async {
    final db = await _db;
    await db.update(_table, movie.toMap(), where: 'id = ?', whereArgs: [movie.id]);
  }

  @override
  Future<void> delete(Movie movie) async {
    final db = await _db;
    await db.delete(_table, where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<Movie?> _findOne(String where, List<Object?> whereArgs) async {
    final db = await _db;
    final rows = await db.query(_table, where: where, whereArgs: whereArgs, limit: 1);
    return rows.isEmpty ? null : Movie.fromMap(rows.first);
  }
}
