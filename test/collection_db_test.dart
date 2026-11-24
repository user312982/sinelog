import 'package:flutter_test/flutter_test.dart';
import 'package:sinelog/app_state.dart';
import 'package:sinelog/models/movie.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  const parasite = Movie(
    id: 496243,
    title: 'Parasite',
    year: '2019',
    rating: 8.5,
    overview: 'x',
    posterUrl: 'https://image.tmdb.org/t/p/w185/p.jpg',
  );

  test('koleksi dan rating tetap ada setelah app dibuka ulang', () async {
    sqfliteFfiInit();
    final db = await openCollectionDb(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );

    final before = MyAppState(db);
    await before.toggleFavorites(parasite);
    await before.setMyRating(parasite, 4);

    // State baru dari database yang sama = app dibuka ulang.
    final after = MyAppState(db);
    await after.load();
    expect(after.favorites, [parasite]);
    expect(after.favorites.single.posterUrl, parasite.posterUrl);
    expect(after.myRatingFor(parasite), 4);

    await after.removeFavorite(parasite);
    final empty = MyAppState(db);
    await empty.load();
    expect(empty.favorites, isEmpty);

    await db.close();
  });
}
