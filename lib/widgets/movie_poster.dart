import 'package:flutter/material.dart';

/// Poster film (56x84, rasio umum poster) dengan fallback ikon kalau
/// posterAsset null atau gagal dimuat. Dipakai di SearchPage & Collection.
class MoviePoster extends StatelessWidget {
  final String? posterAsset;

  const MoviePoster({super.key, required this.posterAsset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: posterAsset != null
          ? Image.asset(
              posterAsset!,
              width: 56,
              height: 84,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const _PosterPlaceholder(),
            )
          : const _PosterPlaceholder(),
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
