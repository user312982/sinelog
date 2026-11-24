import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/movie.dart';

// Diisi lewat: flutter run --dart-define-from-file=tmdb.local.properties
const _apiKey = String.fromEnvironment('TMDB_API_KEY');

/// Jumlah film per halaman di aplikasi. TMDB selalu memberi 20 per halaman,
/// jadi 1 halaman TMDB = 2 halaman aplikasi.
const perPage = 10;
const _tmdbPerPage = 20;

typedef MoviePage = ({List<Movie> movies, int totalPages});

/// Cache respons TMDB di memori. Key: "query|pageTMDB".
/// Map Dart menyimpan urutan masuk, jadi yang paling lama dibuang duluan.
// ponytail: hilang saat app ditutup & tidak kedaluwarsa; pakai penyimpanan
// lokal + waktu kedaluwarsa kalau data harus tetap ada setelah app dibuka ulang.
final _cache = <String, Map<String, dynamic>>{};
const _maxCache = 50;

/// Ambil halaman [page] (mulai 1). Query kosong = film populer.
Future<MoviePage> fetchMovies({String query = '', int page = 1}) async {
  final tmdbPage = ((page - 1) * perPage) ~/ _tmdbPerPage + 1;
  final offset = ((page - 1) * perPage) % _tmdbPerPage;

  final key = '$query|$tmdbPage';
  final body = _cache[key] ??= await _get(query, tmdbPage);
  if (_cache.length > _maxCache) _cache.remove(_cache.keys.first);

  final results = (body['results'] as List)
      .skip(offset)
      .take(perPage)
      .map((json) => Movie.fromJson(json as Map<String, dynamic>))
      .toList();
  // TMDB membatasi maksimal 500 halaman, jadi ambil yang lebih kecil.
  final totalResults = body['total_results'] as int;
  final maxPages = (body['total_pages'] as int) * (_tmdbPerPage ~/ perPage);
  final totalPages = ((totalResults + perPage - 1) ~/ perPage).clamp(
    0,
    maxPages,
  );
  return (movies: results, totalPages: totalPages);
}

/// Request ke TMDB. Kalau gagal melempar Exception, jadi error tidak
/// ikut masuk cache.
Future<Map<String, dynamic>> _get(String query, int tmdbPage) async {
  final uri = Uri.https(
    'api.themoviedb.org',
    query.isEmpty ? '/3/movie/popular' : '/3/search/movie',
    {
      'api_key': _apiKey,
      if (query.isNotEmpty) 'query': query,
      // Jangan tampilkan film dewasa (default TMDB juga false, ditulis eksplisit).
      'include_adult': 'false',
      'language': 'en-US',
      'page': '$tmdbPage',
    },
  );
  final res = await http.get(uri);
  if (res.statusCode == 401) {
    throw Exception(
      'API key TMDB tidak valid/kosong. Jalankan dengan '
      '--dart-define-from-file=tmdb.local.properties',
    );
  }
  if (res.statusCode != 200) {
    throw Exception('TMDB error ${res.statusCode}');
  }
  return jsonDecode(res.body) as Map<String, dynamic>;
}
