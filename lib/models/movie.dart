class Movie {
  final String title;
  final String year;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.rating,
  });
}

final List<Movie> dummyMovies = [
  const Movie(title: 'Inception', year: '2010', rating: 8.8),
  const Movie(title: 'Interstellar', year: '2014', rating: 8.7),
  const Movie(title: 'The Dark Knight', year: '2008', rating: 9.0),
  const Movie(title: 'Spirited Away', year: '2001', rating: 8.6),
  const Movie(title: 'Parasite', year: '2019', rating: 8.5),
  const Movie(title: 'Spiderman', year: '2025', rating: 9.0),
];