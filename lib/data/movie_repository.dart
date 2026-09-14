import 'dart:async';

import '../models/movie.dart';
import '../models/tmdb_dto.dart';
import 'movie_local_datasource.dart';
import 'tmdb_api.dart';

/// Satu-satunya pintu antara UI dan sumber data, sekaligus tempat aturan bisnis.
class MovieRepository {
  final MovieLocalDatasource _local;
  final TmdbApiService _api;
  final _collectionController = StreamController<List<Movie>>.broadcast();

  MovieRepository(this._local, this._api) {
    // Subscriber baru langsung menerima isi koleksi terkini.
    _collectionController.onListen = _emitCollection;
  }

  /// Koleksi dipancarkan ulang setiap ada insert/update/delete, sehingga layar
  /// yang mendengarkan ikut berubah tanpa saling memberi tahu.
  Stream<List<Movie>> get collection => _collectionController.stream;

  Future<Movie?> movieById(int id) => _local.getById(id);

  Future<Movie?> movieByTmdbId(int tmdbId) => _local.getByTmdbId(tmdbId);

  /// Melempar [TmdbException] dengan pesan siap tampil kalau gagal.
  Future<List<TmdbMovie>> search(String query) async =>
      (await _api.searchMovies(query)).results;

  Future<TmdbMovieDetail> detail(int tmdbId) => _api.movieDetail(tmdbId);

  /// UC-01. Mengembalikan false kalau film sudah ada di koleksi.
  Future<bool> addToCollection(Movie movie) async {
    if (await _local.exists(movie.tmdbId)) return false;
    await _local.insert(movie);
    await _emitCollection();
    return true;
  }

  /// UC-03. Rating selalu dikosongkan saat status kembali jadi belum ditonton.
  Future<void> updateStatus(Movie movie, bool isWatched) async {
    await _local.update(movie.copyWith(
      watchedStatus: isWatched ? Movie.watched : Movie.unwatched,
      clearRating: !isWatched,
    ));
    await _emitCollection();
  }

  /// UC-03. Rating hanya berlaku untuk film yang sudah ditonton.
  Future<void> updateRating(Movie movie, int? rating) async {
    if (!movie.isWatched) return;
    await _local.update(movie.copyWith(rating: rating, clearRating: rating == null));
    await _emitCollection();
  }

  /// UC-04.
  Future<void> delete(Movie movie) async {
    await _local.delete(movie);
    await _emitCollection();
  }

  Future<void> _emitCollection() async =>
      _collectionController.add(await _local.getAll());
}
