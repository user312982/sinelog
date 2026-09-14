import 'movie.dart';

/// Bentuk mentah JSON dari TMDB. Semua field nullable karena API bebas
/// mengirim apa saja; pembersihan nilai dilakukan di [toMovie], bukan di sini.

/// Respons `GET /search/movie`.
class TmdbSearchResponse {
  final List<TmdbMovie> results;

  const TmdbSearchResponse({this.results = const []});

  factory TmdbSearchResponse.fromJson(Map<String, dynamic> json) => TmdbSearchResponse(
    results: (json['results'] as List<dynamic>? ?? [])
        .map((item) => TmdbMovie.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}

/// Satu film di hasil pencarian. Field-nya lebih sedikit dari [TmdbMovieDetail].
class TmdbMovie {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? releaseDate;

  const TmdbMovie({
    required this.id,
    this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
  });

  factory TmdbMovie.fromJson(Map<String, dynamic> json) => TmdbMovie(
    id: json['id'] as int,
    title: json['title'] as String?,
    posterPath: json['poster_path'] as String?,
    overview: json['overview'] as String?,
    releaseDate: json['release_date'] as String?,
  );

  /// Jembatan satu-satunya ke model aplikasi.
  Movie toMovie() => Movie(
    tmdbId: id,
    title: title ?? '',
    posterPath: posterPath,
    overview: overview ?? '',
    releaseDate: releaseDate ?? '',
  );
}

/// Respons `GET /movie/{id}` — dipakai layar detail.
class TmdbMovieDetail {
  final int id;
  final String? title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final String? releaseDate;
  final String? tagline;
  final int? runtime;
  final String? status;
  final List<TmdbGenre> genres;
  final double? voteAverage;
  final int? voteCount;

  const TmdbMovieDetail({
    required this.id,
    this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.releaseDate,
    this.tagline,
    this.runtime,
    this.status,
    this.genres = const [],
    this.voteAverage,
    this.voteCount,
  });

  factory TmdbMovieDetail.fromJson(Map<String, dynamic> json) => TmdbMovieDetail(
    id: json['id'] as int,
    title: json['title'] as String?,
    posterPath: json['poster_path'] as String?,
    backdropPath: json['backdrop_path'] as String?,
    overview: json['overview'] as String?,
    releaseDate: json['release_date'] as String?,
    tagline: json['tagline'] as String?,
    runtime: json['runtime'] as int?,
    status: json['status'] as String?,
    genres: (json['genres'] as List<dynamic>? ?? [])
        .map((item) => TmdbGenre.fromJson(item as Map<String, dynamic>))
        .toList(),
    voteAverage: (json['vote_average'] as num?)?.toDouble(),
    voteCount: json['vote_count'] as int?,
  );

  Movie toMovie() => Movie(
    tmdbId: id,
    title: title ?? '',
    posterPath: posterPath,
    overview: overview ?? '',
    releaseDate: releaseDate ?? '',
  );
}

class TmdbGenre {
  final int id;
  final String name;

  const TmdbGenre({required this.id, required this.name});

  factory TmdbGenre.fromJson(Map<String, dynamic> json) =>
      TmdbGenre(id: json['id'] as int, name: json['name'] as String);
}
