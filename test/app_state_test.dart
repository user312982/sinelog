import 'package:flutter_test/flutter_test.dart';
import 'package:sinelog/app_state.dart';
import 'package:sinelog/models/movie.dart';

void main() {
  final inception = dummyMovies[0];

  test('toggleFavorites menambah lalu menghapus film', () {
    final state = MyAppState();

    state.toggleFavorites(inception);
    expect(state.favorites, [inception]);

    state.toggleFavorites(inception);
    expect(state.favorites, isEmpty);
  });

  test('rating dibatasi 1-5', () {
    final state = MyAppState();

    state.setMyRating(inception, 9);
    expect(state.myRatingFor(inception), 5);

    state.setMyRating(inception, 0);
    expect(state.myRatingFor(inception), 1);
  });

  test('menghapus favorit ikut menghapus rating', () {
    final state = MyAppState()..toggleFavorites(inception);
    state.setMyRating(inception, 4);

    state.toggleDeleteFavorites(inception);

    expect(state.favorites, isEmpty);
    expect(state.myRatingFor(inception), isNull);
  });

  test('Movie.fromJson menangani data TMDB yang kosong', () {
    final movie = Movie.fromJson({'id': 1});

    expect(movie.title, '(Tanpa judul)');
    expect(movie.year, '-');
    expect(movie.rating, 0);
  });

  test('Movie.fromJson mengambil tahun dari release_date', () {
    final movie = Movie.fromJson({
      'id': 2,
      'title': 'Parasite',
      'release_date': '2019-05-30',
      'vote_average': 8.5,
    });

    expect(movie.year, '2019');
    expect(movie.rating, 8.5);
  });
}
