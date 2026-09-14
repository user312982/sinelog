import 'package:sinelog/data/movie_local_datasource.dart';
import 'package:sinelog/models/movie.dart';

/// Datasource in-memory — cukup untuk menguji aturan bisnis repository
/// tanpa menyalakan sqflite.
class FakeMovieDatasource implements MovieLocalDatasource {
  final rows = <Movie>[];

  @override
  Future<List<Movie>> getAll() async => List.of(rows);

  @override
  Future<Movie?> getById(int id) async =>
      rows.where((movie) => movie.id == id).firstOrNull;

  @override
  Future<Movie?> getByTmdbId(int tmdbId) async =>
      rows.where((movie) => movie.tmdbId == tmdbId).firstOrNull;

  @override
  Future<bool> exists(int tmdbId) async =>
      rows.any((movie) => movie.tmdbId == tmdbId);

  @override
  Future<void> insert(Movie movie) async {
    rows.add(Movie(
      id: rows.length + 1,
      tmdbId: movie.tmdbId,
      title: movie.title,
      posterPath: movie.posterPath,
      overview: movie.overview,
      releaseDate: movie.releaseDate,
      watchedStatus: movie.watchedStatus,
      rating: movie.rating,
    ));
  }

  @override
  Future<void> update(Movie movie) async {
    final index = rows.indexWhere((row) => row.id == movie.id);
    if (index != -1) rows[index] = movie;
  }

  @override
  Future<void> delete(Movie movie) async {
    rows.removeWhere((row) => row.id == movie.id);
  }
}
