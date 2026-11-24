class Movie {
  final int id;
  final String title;
  final String year;
  final double rating;
  final String overview;
  final String? posterUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.overview,
    this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final releaseDate = json['release_date'] as String?;
    final posterPath = json['poster_path'] as String?;
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? '(Tanpa judul)',
      year: (releaseDate != null && releaseDate.length >= 4)
          ? releaseDate.substring(0, 4)
          : '-',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      overview: json['overview'] as String? ?? '',
      // TMDB mengembalikan path relatif (mis. "/abc.jpg"), digabung dengan
      // base URL gambar TMDB.
      posterUrl: posterPath != null
          ? 'https://image.tmdb.org/t/p/w185$posterPath'
          : null,
    );
  }

  /// Baris tabel `movies` di SQLite (lihat app_state.dart).
  factory Movie.fromMap(Map<String, Object?> map) => Movie(
    id: map['id'] as int,
    title: map['title'] as String,
    year: map['year'] as String,
    rating: (map['rating'] as num).toDouble(),
    overview: map['overview'] as String,
    posterUrl: map['posterUrl'] as String?,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'year': year,
    'rating': rating,
    'overview': overview,
    'posterUrl': posterUrl,
  };

  // Dua Movie dianggap sama kalau id-nya sama, supaya status favorit tetap
  // cocok walau objeknya dibuat ulang (misal dari hasil pencarian baru).
  @override
  bool operator ==(Object other) => other is Movie && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
