import 'package:flutter_test/flutter_test.dart';
import 'package:sinelog/data/movie_repository.dart';
import 'package:sinelog/data/tmdb_api.dart';
import 'package:sinelog/models/movie.dart';
import 'package:sinelog/models/tmdb_dto.dart';

import 'fakes/fake_movie_datasource.dart';

void main() {
  late FakeMovieDatasource datasource;
  late MovieRepository repository;

  const theMatrix = TmdbMovie(
    id: 603,
    title: 'The Matrix',
    posterPath: '/poster.jpg',
    overview: 'Sinopsis',
    releaseDate: '1999-03-31',
  );

  setUp(() {
    datasource = FakeMovieDatasource();
    // API key sengaja kosong: test ini tidak boleh menyentuh jaringan.
    repository = MovieRepository(datasource, TmdbApiService(apiKey: ''));
  });

  test('film baru masuk koleksi dengan status belum ditonton dan tanpa rating', () async {
    expect(await repository.addToCollection(theMatrix.toMovie()), isTrue);

    final saved = datasource.rows.single;
    expect(saved.watchedStatus, Movie.unwatched);
    expect(saved.rating, isNull);
  });

  test('film duplikat ditolak', () async {
    await repository.addToCollection(theMatrix.toMovie());

    expect(await repository.addToCollection(theMatrix.toMovie()), isFalse);
    expect(datasource.rows, hasLength(1));
  });

  test('rating diabaikan selama film belum ditonton', () async {
    await repository.addToCollection(theMatrix.toMovie());

    await repository.updateRating(datasource.rows.single, 5);
    expect(datasource.rows.single.rating, isNull);

    await repository.updateStatus(datasource.rows.single, true);
    await repository.updateRating(datasource.rows.single, 5);
    expect(datasource.rows.single.rating, 5);
  });

  test('rating direset saat status kembali belum ditonton', () async {
    await repository.addToCollection(theMatrix.toMovie());
    await repository.updateStatus(datasource.rows.single, true);
    await repository.updateRating(datasource.rows.single, 4);

    await repository.updateStatus(datasource.rows.single, false);
    expect(datasource.rows.single.rating, isNull);
  });

  test('status dan rating berdiri sendiri per film', () async {
    await repository.addToCollection(theMatrix.toMovie());
    await repository.addToCollection(
      const TmdbMovie(id: 604, title: 'Matrix Reloaded', releaseDate: '2003-05-15').toMovie(),
    );
    await repository.addToCollection(
      const TmdbMovie(id: 605, title: 'Matrix Revolutions', releaseDate: '2003-11-05').toMovie(),
    );

    await repository.updateStatus(datasource.rows[0], true);
    await repository.updateRating(datasource.rows[0], 5);
    await repository.updateStatus(datasource.rows[1], true);
    await repository.updateRating(datasource.rows[1], 3);

    expect(datasource.rows.map((movie) => movie.rating).toList(), [5, 3, null]);
    expect(datasource.rows.where((movie) => movie.isWatched), hasLength(2));
  });

  test('hapus film mengosongkan koleksi', () async {
    await repository.addToCollection(theMatrix.toMovie());

    await repository.delete(datasource.rows.single);
    expect(datasource.rows, isEmpty);
  });

  test('koleksi dipancarkan ulang setiap ada perubahan', () async {
    final emitted = <int>[];
    final subscription =
        repository.collection.listen((movies) => emitted.add(movies.length));

    await repository.addToCollection(theMatrix.toMovie());
    await repository.delete(datasource.rows.single);
    await Future<void>.delayed(Duration.zero); // beri kesempatan stream terkirim
    await subscription.cancel();

    // 0 = isi awal saat mulai mendengarkan, lalu 1 setelah tambah, 0 setelah hapus.
    expect(emitted, [0, 1, 0]);
  });
}
