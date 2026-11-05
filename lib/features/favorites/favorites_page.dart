import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state.dart';
import '../../models/movie.dart';
import '../../widgets/movie_poster.dart';

class FavoritePages extends StatelessWidget {
  const FavoritePages({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return const Center(child: Text('There no Favorites yet.'));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('You have ${appState.favorites.length}'),
        ),
        for (var fav in appState.favorites) _FavoriteCard(movie: fav),
      ],
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final Movie movie;

  const _FavoriteCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final myRating = appState.myRatingFor(movie) ?? 0;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          spacing: 12,
          children: [
            MoviePoster(posterAsset: movie.posterAsset),
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
                        onPressed: () {
                          appState.toggleDeleteFavorites(movie);
                        },
                        icon: const Icon(Icons.bookmark, color: Colors.red),
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
                          Text(movie.rating.toString()),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    spacing: 6,
                    children: [
                      Row(
                        children: [
                          for (var i = 1; i <= 5; i++)
                            GestureDetector(
                              onTap: () => appState.setMyRating(movie, i),
                              child: Icon(
                                i <= myRating ? Icons.star : Icons.star_border,
                                size: 22,
                                color: Colors.yellow,
                              ),
                            ),
                        ],
                      ),
                      Text(
                        myRating > 0
                            ? 'Rating saya: $myRating/5'
                            : 'Beri rating',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
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
