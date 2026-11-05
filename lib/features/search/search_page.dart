import 'package:flutter/material.dart';

import '../../models/movie.dart';
import 'movie_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredMovie = dummyMovies.where((movie) {
      final titleLower = movie.title.toLowerCase();
      final searchLower = searchQuery.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SearchBar(
              hintText: 'Cari Film...',
              leading: const Icon(Icons.search_rounded),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredMovie.isEmpty
                ? const Center(child: Text('Film Tidak Ditemukan.'))
                : ListView.builder(
                    itemCount: filteredMovie.length,
                    itemBuilder: (context, index) {
                      return MovieCard(movie: filteredMovie[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
