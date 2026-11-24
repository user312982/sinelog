import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:sinelog/services/tmdb_api.dart';

void main() {
  // TMDB palsu: tiap halaman berisi 20 film, id = urutan global (0..44).
  final requestedPages = <String>[];
  final fakeTmdb = MockClient((request) async {
    final tmdbPage = int.parse(request.url.queryParameters['page']!);
    requestedPages.add('$tmdbPage');
    final start = (tmdbPage - 1) * 20;
    final ids = [for (var i = start; i < start + 20 && i < 45; i++) i];
    final results = ids.map((i) => '{"id":$i,"title":"Film $i"}').join(',');
    return http.Response(
      '{"results":[$results],"total_results":45,"total_pages":3}',
      200,
    );
  });

  Future<MoviePage> fetch(int page) =>
      http.runWithClient(() => fetchMovies(page: page), () => fakeTmdb);

  test('1 halaman TMDB (20) dibagi jadi 2 halaman aplikasi (10)', () async {
    requestedPages.clear();

    final p1 = await fetch(1);
    expect(p1.movies.map((m) => m.id), List.generate(10, (i) => i));

    final p2 = await fetch(2);
    expect(p2.movies.map((m) => m.id), List.generate(10, (i) => i + 10));

    final p3 = await fetch(3);
    expect(p3.movies.map((m) => m.id), List.generate(10, (i) => i + 20));

    final p5 = await fetch(5);
    expect(p5.movies.map((m) => m.id), [40, 41, 42, 43, 44]);

    // Halaman 2 memakai cache dari TMDB page 1, jadi tidak request lagi.
    expect(requestedPages, ['1', '2', '3']);
    expect(p1.totalPages, 5); // 45 film / 10 = 5 halaman
  });

  test('halaman yang sudah dibuka diambil dari cache', () async {
    requestedPages.clear();
    await fetch(1);
    await fetch(2);
    await fetch(5);
    expect(requestedPages, isEmpty); // semua sudah ada dari test sebelumnya
  });
}
