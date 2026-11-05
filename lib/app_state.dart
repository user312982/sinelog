import 'package:flutter/foundation.dart';

import 'models/movie.dart';

class MyAppState extends ChangeNotifier {
  var favorites = <Movie>[];

  // Rating pribadi (1-5) per film favorit, terpisah dari rating asli film.
  // Key: Movie.id.
  final myRatings = <int, int>{};

  void toggleFavorites(Movie movie) {
    if (favorites.contains(movie)) {
      favorites.remove(movie);
      myRatings.remove(movie.id);
    } else {
      favorites.add(movie);
    }
    notifyListeners();
  }

  void toggleDeleteFavorites(Movie movie) {
    favorites.remove(movie);
    myRatings.remove(movie.id);
    notifyListeners();
  }

  void setMyRating(Movie movie, int stars) {
    myRatings[movie.id] = stars.clamp(1, 5);
    notifyListeners();
  }

  int? myRatingFor(Movie movie) => myRatings[movie.id];
}
