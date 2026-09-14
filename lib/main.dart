import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import 'data/movie_repository.dart';
import 'data/sqflite_movie_datasource.dart';
import 'data/tmdb_api.dart';
import 'movie_store.dart';
import 'screens.dart';

const _tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');

void main() {
  if (kIsWeb) databaseFactory = databaseFactoryFfiWeb;
  runApp(const SinelogApp());
}

class SinelogApp extends StatelessWidget {
  /// Diisi hanya oleh test, supaya app bisa dibangun tanpa sqflite asli.
  final MovieRepository? repository;

  const SinelogApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    return Provider<MovieRepository>(
      create: (_) =>
          repository ??
          MovieRepository(
            SqfliteMovieDatasource(),
            TmdbApiService(apiKey: _tmdbApiKey),
          ),
      child: ChangeNotifierProvider(
        create: (context) => MovieStore(context.read<MovieRepository>()),
        child: MaterialApp(
          title: 'Sinelog',
          theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo)),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.indigo,
              brightness: Brightness.dark,
            ),
          ),
          home: const RootTabs(),
        ),
      ),
    );
  }
}
