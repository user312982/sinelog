import 'package:flutter/material.dart';

import '../features/favorites/favorites_page.dart';
import '../features/search/search_page.dart';

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

    return Scaffold(
      body: page,
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
  }
}
