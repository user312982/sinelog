import 'package:flutter/material.dart';

/// Poster film (56x84, rasio umum poster) dari URL TMDB, dengan fallback
/// ikon kalau posterUrl null atau gagal dimuat. Dipakai di Search & Collection.
class MoviePoster extends StatelessWidget {
  final String? posterUrl;

  const MoviePoster({super.key, required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    final url = posterUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: url == null
          ? const _PosterPlaceholder()
          : Image.network(
              url,
              width: 56,
              height: 84,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _PosterPlaceholder(),
            ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 84,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Icon(Icons.movie),
    );
  }
}
