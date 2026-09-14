import 'package:flutter_test/flutter_test.dart';
import 'package:sinelog/data/movie_repository.dart';
import 'package:sinelog/data/tmdb_api.dart';
import 'package:sinelog/main.dart';

import 'fakes/fake_movie_datasource.dart';

void main() {
  testWidgets('app terpasang dan menampilkan koleksi kosong', (tester) async {
    final repository =
        MovieRepository(FakeMovieDatasource(), TmdbApiService(apiKey: ''));

    await tester.pumpWidget(SinelogApp(repository: repository));
    await tester.pump();

    expect(find.text('Koleksi masih kosong'), findsOneWidget);
  });
}
