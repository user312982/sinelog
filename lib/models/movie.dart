/// Film di koleksi lokal (UC-01..04).
class Movie {
  static const watched = 'watched';
  static const unwatched = 'unwatched';

  final int id;
  final int tmdbId;
  final String title;
  final String? posterPath;
  final String overview;
  final String releaseDate;
  final String watchedStatus;
  final int? rating;

  const Movie({
    this.id = 0,
    required this.tmdbId,
    required this.title,
    this.posterPath,
    required this.overview,
    required this.releaseDate,
    this.watchedStatus = unwatched,
    this.rating,
  });

  bool get isWatched => watchedStatus == watched;

  Movie copyWith({
    String? watchedStatus,
    int? rating,
    bool clearRating = false,
  }) {
    return Movie(
      id: id,
      tmdbId: tmdbId,
      title: title,
      posterPath: posterPath,
      overview: overview,
      releaseDate: releaseDate,
      watchedStatus: watchedStatus ?? this.watchedStatus,
      rating: clearRating ? null : (rating ?? this.rating),
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'tmdbId': tmdbId,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
    'releaseDate': releaseDate,
    'watchedStatus': watchedStatus,
    'rating': rating,
  };

  factory Movie.fromMap(Map<String, Object?> map) => Movie(
    id: map['id'] as int,
    tmdbId: map['tmdbId'] as int,
    title: map['title'] as String,
    posterPath: map['posterPath'] as String?,
    overview: map['overview'] as String,
    releaseDate: map['releaseDate'] as String,
    watchedStatus: map['watchedStatus'] as String,
    rating: map['rating'] as int?,
  );

  
}
