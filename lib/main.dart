import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  var favorites = <Movie>[];

  void toggleFavorites(Movie movie) {
    if (favorites.contains(movie)) {
      favorites.remove(movie);
    } else {
      favorites.add(movie);
    }
    notifyListeners();
  }

  void toggleDeleteFavorites(Movie movie) {
    favorites.remove(movie);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const SearchPage();
        break;
      case 1:
        page = const FavoritePages();
        break;
      default:
        throw UnimplementedError('no Widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: page,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            destinations: const [
              NavigationDestination(icon: Icon(Icons.search), label: ('Cari')),
              NavigationDestination(
                icon: Icon(Icons.video_collection_sharp),
                label: ('Collection'),
              ),
            ],
          ),
        );
      },
    );
  }
}

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

class FavoritePages extends StatelessWidget {
  const FavoritePages({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(child: Text('There no Favorites yet.'));
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text('You have ${appState.favorites.length}'),
        ),
        for (var fav in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(fav.title),
            subtitle: Text(fav.year),
            trailing: IconButton(
              onPressed: () {
                appState.toggleDeleteFavorites(fav);
              },
              icon: Icon(Icons.delete),
            ),
          ),
      ],
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final isFavorite = appState.favorites.contains(movie);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: ListTile(
        leading: const Icon(Icons.movie, size: 36),
        title: Text(movie.title),
        subtitle: Text(movie.year),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 2),
            Text(movie.rating.toString()),
            IconButton(
                onPressed: () {
                  appState.toggleFavorites(movie);
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null,
                ),
            )
          ],
        ),
      ),
    );
  }
}
