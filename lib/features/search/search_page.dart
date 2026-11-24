import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/tmdb_api.dart';
import 'movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Timer? _debounce;
  String _query = '';
  int _page = 1;
  // Langsung isi film populer halaman 1 saat halaman dibuka.
  late Future<MoviePage> _results = fetchMovies();

  void _load({String? query, int page = 1}) {
    setState(() {
      _query = query ?? _query;
      _page = page;
      _results = fetchMovies(query: _query, page: _page);
    });
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    // Tunggu user berhenti mengetik dulu supaya tidak hit API tiap huruf.
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _load(query: value.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Cari film...',
              leading: const Icon(Icons.search_rounded),
              onChanged: _onChanged,
              trailing: [
                IconButton(
                  tooltip: 'Tentang',
                  icon: const Icon(Icons.info_outline),
                  // Atribusi wajib dari syarat penggunaan API TMDB.
                  onPressed: () => showAboutDialog(
                    context: context,
                    applicationName: 'Sinelog',
                    applicationIcon: Image.asset(
                      'assets/images/logo.png',
                      width: 48,
                    ),
                    children: [
                      // Logo resmi TMDB, wajib lebih kecil dari logo app.
                      // Kalau file belum ada, tidak tampil apa-apa.
                      Image.asset(
                        'assets/images/tmdb_logo.png',
                        height: 36,
                        alignment: Alignment.centerLeft,
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Data dan poster film dari The Movie Database (TMDB).\n'
                        'This product uses the TMDB API but is not endorsed '
                        'or certified by TMDB.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<MoviePage>(
              future: _results,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Gagal memuat. Periksa koneksi internet.'),
                  );
                }
                final data = snapshot.data!;
                if (data.movies.isEmpty) {
                  return const Center(child: Text('Film tidak ditemukan.'));
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.movies.length,
                        itemBuilder: (context, index) =>
                            MovieCard(movie: data.movies[index]),
                      ),
                    ),
                    _Pagination(
                      page: _page,
                      totalPages: data.totalPages,
                      onSelect: (page) => _load(page: page),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Pagination extends StatelessWidget {
  // Default lebar minimum tombol 64px, 5 tombol + panah tidak muat di HP.
  static final _compact = ButtonStyle(
    minimumSize: WidgetStateProperty.all(const Size(40, 40)),
    padding: WidgetStateProperty.all(EdgeInsets.zero),
  );

  final int page;
  final int totalPages;
  final ValueChanged<int> onSelect;

  const _Pagination({
    required this.page,
    required this.totalPages,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final start = (page - 2).clamp(1, (totalPages - 4).clamp(1, totalPages));
    final end = (start + 4).clamp(1, totalPages);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            tooltip: 'Sebelumnya',
            onPressed: page > 1 ? () => onSelect(page - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          for (var p = start; p <= end; p++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: p == page
                  ? FilledButton(
                      style: _compact,
                      onPressed: () {},
                      child: Text('$p'),
                    )
                  : TextButton(
                      style: _compact,
                      onPressed: () => onSelect(p),
                      child: Text('$p'),
                    ),
            ),
          IconButton(
            tooltip: 'Berikutnya',
            onPressed: page < totalPages ? () => onSelect(page + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
