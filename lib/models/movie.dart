class Movie {
  final int id;
  final String title;
  final String year;
  final double rating;
  final String overview;
  final String? posterAsset;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.overview,
    this.posterAsset,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final releaseDate = json['release_date'] as String?;
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? '(Tanpa judul)',
      year: (releaseDate != null && releaseDate.length >= 4)
          ? releaseDate.substring(0, 4)
          : '-',
      rating: (json['vote_average'] as num?)?.toDouble() ?? 0,
      overview: json['overview'] as String? ?? '',
      // TMDB mengembalikan path relatif (mis. "/abc.jpg") yang perlu
      // digabung dengan base URL gambar TMDB, bukan nama asset lokal.
      posterAsset: null,
    );
  }

  // Dua Movie dianggap sama kalau id-nya sama, supaya status favorit tetap
  // cocok walau objeknya dibuat ulang (misal dari hasil pencarian baru).
  @override
  bool operator ==(Object other) => other is Movie && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

final List<Movie> dummyMovies = [
  const Movie(
    id: 27205,
    title: 'Inception',
    year: '2010',
    rating: 8.8,
    overview:
        'Seorang pencuri yang bekerja dengan menyusup ke alam bawah sadar '
        'orang lain lewat mimpi, diberi tugas terbalik: menanamkan sebuah '
        'ide, bukan mencurinya.',
    posterAsset: 'assets/images/posters/inception.jpg',
  ),
  const Movie(
    id: 157336,
    title: 'Interstellar',
    year: '2014',
    rating: 8.7,
    overview:
        'Sekelompok penjelajah memanfaatkan lubang cacing yang baru '
        'ditemukan untuk melampaui batas perjalanan antariksa manusia dan '
        'menaklukkan jarak yang sangat jauh dalam misi antarbintang.',
    posterAsset: 'assets/images/posters/interstellar.jpg',
  ),
  const Movie(
    id: 155,
    title: 'The Dark Knight',
    year: '2008',
    rating: 9.0,
    overview:
        'Batman harus menerima salah satu ujian psikologis dan fisik '
        'terbesarnya saat melawan Joker, yang mengancam membuat kota '
        'Gotham dilanda kekacauan.',
    posterAsset: 'assets/images/posters/dark_knight.jpg',
  ),
  const Movie(
    id: 129,
    title: 'Spirited Away',
    year: '2001',
    rating: 8.6,
    overview:
        'Seorang gadis kecil tersesat di dunia roh setelah orang tuanya '
        'berubah menjadi babi oleh seorang penyihir, dan ia harus bekerja '
        'di pemandian roh untuk menyelamatkan mereka.',
    posterAsset: 'assets/images/posters/spirited_away.jpg',
  ),
  const Movie(
    id: 496243,
    title: 'Parasite',
    year: '2019',
    rating: 8.5,
    overview:
        'Keluarga miskin Kim perlahan menyusup ke kehidupan keluarga kaya '
        'Park, memicu rangkaian kejadian tak terduga yang mengancam '
        'keduanya.',
    posterAsset: 'assets/images/posters/parasite.jpg',
  ),
  const Movie(
    id: 1930966,
    title: 'Spiderman',
    year: '2025',
    rating: 9.0,
    overview: 'Film fiksi untuk keperluan data contoh — belum dirilis.',
    posterAsset: 'assets/images/posters/spiderman.jpg',
  ),
];
