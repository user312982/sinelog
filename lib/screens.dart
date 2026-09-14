import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/movie.dart';
import 'models/tmdb_dto.dart';
import 'movie_store.dart';

// Layar sementara tahap 2.5 — dipecah jadi lib/screens/ + lib/widgets/ di tahap 4-5.

String? _posterUrl(String? path) =>
    path == null ? null : 'https://image.tmdb.org/t/p/w342$path';

String _releaseYear(String? releaseDate) =>
    (releaseDate == null || releaseDate.length < 4) ? '-' : releaseDate.substring(0, 4);

class _Poster extends StatelessWidget {
  final String? path;
  final double width;

  const _Poster(this.path, {this.width = 56});

  @override
  Widget build(BuildContext context) {
    final url = _posterUrl(path);
    final height = width * 1.5;
    final placeholderColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: width,
        height: height,
        color: placeholderColor,
        child: url == null
            ? const Icon(Icons.movie_outlined, semanticLabel: 'Poster tidak tersedia')
            : CachedNetworkImage(imageUrl: url, fit: BoxFit.cover),
      ),
    );
  }
}

class RootTabs extends StatefulWidget {
  const RootTabs({super.key});

  @override
  State<RootTabs> createState() => _RootTabsState();
}

class _RootTabsState extends State<RootTabs> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          Image.asset('assets/images/logo.png', height: 28),
          const SizedBox(width: 8),
          const Text('Sinelog'),
        ]),
      ),
      // IndexedStack menjaga isi tab Cari saat pindah tab.
      body: IndexedStack(
        index: _selectedTab,
        children: const [CollectionTab(), SearchTab()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedTab,
        onDestinationSelected: (index) => setState(() => _selectedTab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.video_library_outlined),
            selectedIcon: Icon(Icons.video_library),
            label: 'Koleksi',
          ),
          NavigationDestination(icon: Icon(Icons.search), label: 'Cari'),
        ],
      ),
    );
  }
}

/// UC-02: daftar koleksi.
class CollectionTab extends StatelessWidget {
  const CollectionTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MovieStore>();
    final movies = store.all;

    if (movies.isEmpty) {
      return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(
            'assets/images/logo.png',
            height: 96,
            opacity: const AlwaysStoppedAnimation(0.4),
          ),
          const SizedBox(height: 16),
          const Text('Koleksi masih kosong'),
          const Text('Cari film di tab Cari untuk menambahkan.'),
        ]),
      );
    }

    return ListView.builder(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return ListTile(
          leading: _Poster(movie.posterPath),
          title: Text(movie.title),
          subtitle: Text([
            _releaseYear(movie.releaseDate),
            if (movie.rating != null) '★ ${movie.rating}/5',
          ].join(' · ')),
          trailing: IconButton(
            icon: Icon(
              movie.isWatched ? Icons.check_circle : Icons.check_circle_outline,
            ),
            tooltip: movie.isWatched ? 'Tandai belum ditonton' : 'Tandai sudah ditonton',
            onPressed: () => store.toggleWatched(movie),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MovieDetailScreen(movieId: movie.id)),
          ),
        );
      },
    );
  }
}

/// UC-01: cari film di TMDB lalu tambahkan ke koleksi.
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _queryController = TextEditingController();
  Future<List<TmdbMovie>>? _searchResults;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _runSearch() {
    final query = _queryController.text.trim();
    if (query.isEmpty) return;
    // Future dibuat di luar setState: callback setState tidak boleh asinkron.
    final pendingResults = context.read<MovieStore>().search(query);
    setState(() {
      _searchResults = pendingResults;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: _queryController,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _runSearch(),
          decoration: InputDecoration(
            hintText: 'Judul film...',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: _runSearch,
            ),
          ),
        ),
      ),
      Expanded(child: _buildResults()),
    ]);
  }

  Widget _buildResults() {
    if (_searchResults == null) {
      return const Center(child: Text('Ketik judul lalu tekan cari.'));
    }

    return FutureBuilder<List<TmdbMovie>>(
      future: _searchResults,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Pesan TmdbException sudah berbahasa Indonesia dan siap tampil.
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Text('${snapshot.error}', textAlign: TextAlign.center),
          );
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) {
          return const Center(child: Text('Film tidak ditemukan.'));
        }

        final store = context.watch<MovieStore>();
        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];
            final alreadySaved = store.contains(result.id);
            return ListTile(
              leading: _Poster(result.posterPath),
              title: Text(result.title ?? 'Tanpa judul'),
              subtitle: Text(_releaseYear(result.releaseDate)),
              trailing: IconButton(
                icon: Icon(alreadySaved ? Icons.done : Icons.add),
                tooltip: alreadySaved ? 'Sudah di koleksi' : 'Tambah ke koleksi',
                onPressed: alreadySaved ? null : () => store.add(result),
              ),
            );
          },
        );
      },
    );
  }
}

/// UC-02 detail, UC-03 status & rating, UC-04 hapus.
class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailScreen({super.key, required this.movieId});

  Future<void> _confirmDelete(BuildContext context, Movie movie) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus dari koleksi?'),
        content: Text('"${movie.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await context.read<MovieStore>().remove(movie);
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<MovieStore>();
    final movie = store.byId(movieId);

    if (movie == null) {
      return const Scaffold(body: Center(child: Text('Film sudah dihapus.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Hapus dari koleksi',
            onPressed: () => _confirmDelete(context, movie),
          ),
        ],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Center(child: _Poster(movie.posterPath, width: 160)),
        const SizedBox(height: 16),
        Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
        Text(_releaseYear(movie.releaseDate)),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Sudah ditonton'),
          value: movie.isWatched,
          onChanged: (_) => store.toggleWatched(movie),
        ),
        _RatingPicker(movie: movie),
        const SizedBox(height: 16),
        Text(movie.overview.isEmpty ? 'Tidak ada sinopsis.' : movie.overview),
      ]),
    );
  }
}

/// Rating 1-5 hanya aktif untuk film yang sudah ditonton (aturan di repository).
class _RatingPicker extends StatelessWidget {
  final Movie movie;

  const _RatingPicker({required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!movie.isWatched) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          'Tandai sebagai sudah ditonton untuk memberi rating.',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      );
    }

    final store = context.read<MovieStore>();
    return Row(
      children: List.generate(5, (index) {
        final star = index + 1;
        final isFilled = star <= (movie.rating ?? 0);
        return IconButton(
          icon: Icon(isFilled ? Icons.star : Icons.star_outline),
          tooltip: 'Beri $star bintang',
          // Menekan bintang yang sama menghapus rating.
          onPressed: () => store.setRating(movie, movie.rating == star ? null : star),
        );
      }),
    );
  }
}
