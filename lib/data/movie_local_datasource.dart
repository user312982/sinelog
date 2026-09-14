import '../models/movie.dart';

/// Sumber data lokal koleksi film.
///
/// Abstrak supaya repository bisa diuji dengan datasource in-memory, tanpa
/// menyalakan sqflite asli yang butuh device.
abstract class MovieLocalDatasource {
  Future<List<Movie>> getAll();
  Future<Movie?> getById(int id);
  Future<Movie?> getByTmdbId(int tmdbId);
  Future<bool> exists(int tmdbId);
  Future<void> insert(Movie movie);
  Future<void> update(Movie movie);
  Future<void> delete(Movie movie);
}
