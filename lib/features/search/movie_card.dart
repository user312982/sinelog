import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';

import '../../app_state.dart';
import '../../models/movie.dart';
import '../../widgets/movie_poster.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final isFavorite = appState.favorites.contains(movie);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          spacing: 12,
          children: [
            MoviePoster(posterUrl: movie.posterUrl),
            Expanded(
              child: Column(
                spacing: 4,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          movie.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () => appState.toggleFavorites(movie),
                        icon: Icon(
                          isFavorite ? Icons.bookmark : Icons.bookmark_outline,
                          color: isFavorite ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Text(movie.year),
                      Row(
                        spacing: 2,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          Text(movie.rating.toStringAsFixed(1)),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ReadMoreText(
                      movie.overview,
                      trimMode: TrimMode.Line,
                      trimLines: 2,
                      colorClickableText: Colors.pink,
                      trimCollapsedText: 'Selengkapnya',
                      trimExpandedText: 'Ringkas',
                      moreStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
