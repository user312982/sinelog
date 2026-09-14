import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/tmdb_dto.dart';

const _baseUrl = 'https://api.themoviedb.org/3/';

/// Kegagalan TMDB dengan pesan yang sudah siap ditampilkan ke pengguna.
///
/// Pesan dirakit di sini, bukan di UI, supaya tidak ditulis ulang di setiap layar.
class TmdbException implements Exception {
  final String message;

  TmdbException(this.message);

  @override
  String toString() => message;
}

class TmdbApiService {
  final String apiKey;
  final http.Client _client;

  TmdbApiService({required this.apiKey, http.Client? client})
      : _client = client ?? http.Client();

  Future<TmdbSearchResponse> searchMovies(String query) async {
    final json = await _get('search/movie', {'query': query});
    return TmdbSearchResponse.fromJson(json);
  }

  Future<TmdbMovieDetail> movieDetail(int tmdbId) async {
    final json = await _get('movie/$tmdbId', const {});
    return TmdbMovieDetail.fromJson(json);
  }

  Future<Map<String, dynamic>> _get(String path, Map<String, String> query) async {
    if (apiKey.isEmpty) {
      throw TmdbException(
        'API key TMDB belum diisi. Isi tmdb.local.properties lalu jalankan lewat ./run.sh',
      );
    }

    final uri = Uri.parse('$_baseUrl$path').replace(
      queryParameters: {...query, 'api_key': apiKey},
    );

    final http.Response response;
    try {
      response = await _client.get(uri);
    } on SocketException {
      throw TmdbException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    }

    if (response.statusCode == 401) {
      throw TmdbException('API key TMDB tidak valid.');
    }
    if (response.statusCode != 200) {
      throw TmdbException('Gagal memuat data dari TMDB (kode ${response.statusCode}).');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
