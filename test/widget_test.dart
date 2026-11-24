import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sinelog/main.dart';

void main() {
  // Respons palsu TMDB supaya test tidak butuh jaringan / API key.
  // Halaman awal = film populer (Inception), cari "parasite" = Parasite.
  final fakeTmdb = MockClient((request) async {
    final isSearch = request.url.path == '/3/search/movie';
    if (isSearch) expect(request.url.queryParameters['query'], 'parasite');
    final (id, title) = isSearch ? (496243, 'Parasite') : (27205, 'Inception');
    return http.Response(
      '{"results":[{"id":$id,"title":"$title","release_date":"2019-05-30",'
      '"vote_average":8.5,"overview":"x"}],'
      '"total_results":1,"total_pages":1}',
      200,
    );
  });

  testWidgets('cari film, tambah ke koleksi, lalu hapus', (tester) async {
    await http.runWithClient(() async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();
      expect(find.text('Inception'), findsOneWidget);

      // Mencari Film (debounce 400ms, lalu tunggu respons)
      await tester.enterText(find.byType(SearchBar), 'parasite');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('Parasite'), findsOneWidget);
      expect(find.text('Inception'), findsNothing);

      // Menambah film ke koleksi
      await tester.tap(find.byIcon(Icons.bookmark_outline));
      await tester.pump();

      // Melihat koleksi film
      await tester.tap(find.text('Koleksi'));
      await tester.pumpAndSettle();
      expect(find.text('Parasite'), findsOneWidget);

      // Mengubah rating film
      await tester.tap(find.byIcon(Icons.star_border).at(2));
      await tester.pump();
      expect(find.text('Rating saya: 3/5'), findsOneWidget);

      // Menghapus film
      await tester.tap(find.byIcon(Icons.bookmark));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus'));
      await tester.pumpAndSettle();
      expect(find.text('Parasite'), findsNothing);
    }, () => fakeTmdb);
  });
}
