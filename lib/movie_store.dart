import 'dart:async';

import 'package:flutter/foundation.dart';

import 'data/movie_repository.dart';
import 'models/movie.dart';
import 'models/tmdb_dto.dart';

/// State sementara untuk UI tahap 2.5.
///
/// Akan dipecah jadi CollectionStore, SearchStore, dan DetailStore di tahap 3.
class MovieStore extends ChangeNotifier {
  final MovieRepository _repository;
  late final StreamSubscription<List<Movie>> _collectionSubscription;

  List<Movie> _collection = [];

  MovieStore(this._repository) {
    _collectionSubscription = _repository.collection.listen((movies) {
      _collection = movies;
      notifyListeners();
    });
  }

  List<Movie> get all => _collection;
  List<Movie> get watched => _collection.where((movie) => movie.isWatched).toList();
  List<Movie> get unwatched => _collection.where((movie) => !movie.isWatched).toList();

  bool contains(int tmdbId) => _collection.any((movie) => movie.tmdbId == tmdbId);

  Movie? byId(int id) => _collection.where((movie) => movie.id == id).firstOrNull;

  Future<List<TmdbMovie>> search(String query) =>
      _repository.search(query.trim());

  Future<void> add(TmdbMovie movie) => _repository.addToCollection(movie.toMovie());

  Future<void> toggleWatched(Movie movie) =>
      _repository.updateStatus(movie, !movie.isWatched);

  Future<void> setRating(Movie movie, int? rating) =>
      _repository.updateRating(movie, rating);

  Future<void> remove(Movie movie) => _repository.delete(movie);

  @override
  void dispose() {
    _collectionSubscription.cancel();
    super.dispose();
  }
}
