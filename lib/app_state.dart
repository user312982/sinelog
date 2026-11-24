import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import 'models/movie.dart';

/// Buka database koleksi. [factory] dan [path] hanya diganti saat test.
Future<Database> openCollectionDb({
  DatabaseFactory? factory,
  String? path,
}) async {
  factory ??= databaseFactory;
  return factory.openDatabase(
    path ?? p.join(await factory.getDatabasesPath(), 'sinelog.db'),
    options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE movies(
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          year TEXT NOT NULL,
          rating REAL NOT NULL,
          overview TEXT NOT NULL,
          posterUrl TEXT,
          myRating INTEGER,
          addedAt INTEGER NOT NULL
        )'''),
    ),
  );
}

/// Koleksi film + rating pribadi. UI langsung berubah, lalu perubahan
/// ditulis ke SQLite. Tanpa [_db] (misal di test) data hanya di memori.
class MyAppState extends ChangeNotifier {
  MyAppState([this._db]);

  final Database? _db;
  var favorites = <Movie>[];

  // Rating pribadi (1-5) per film favorit, terpisah dari rating asli film.
  // Key: Movie.id.
  final myRatings = <int, int>{};

  /// Isi state dari database. Dipanggil sekali saat app dibuka.
  Future<void> load() async {
    final rows = await _db?.query('movies', orderBy: 'addedAt') ?? [];
    favorites = [for (final row in rows) Movie.fromMap(row)];
    for (final row in rows) {
      if (row['myRating'] case final int stars) {
        myRatings[row['id'] as int] = stars;
      }
    }
    notifyListeners();
  }

  Future<void> toggleFavorites(Movie movie) async {
    if (favorites.contains(movie)) return removeFavorite(movie);
    favorites.add(movie);
    notifyListeners();
    await _db?.insert('movies', {
      ...movie.toMap(),
      'addedAt': DateTime.now().millisecondsSinceEpoch,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(Movie movie) async {
    favorites.remove(movie);
    myRatings.remove(movie.id);
    notifyListeners();
    await _db?.delete('movies', where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<void> setMyRating(Movie movie, int stars) async {
    final value = myRatings[movie.id] = stars.clamp(1, 5);
    notifyListeners();
    await _db?.update(
      'movies',
      {'myRating': value},
      where: 'id = ?',
      whereArgs: [movie.id],
    );
  }

  int? myRatingFor(Movie movie) => myRatings[movie.id];
}
