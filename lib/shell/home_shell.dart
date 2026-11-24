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
    return Scaffold(
      // IndexedStack menyimpan semua tab, jadi state halaman (teks pencarian,
      // nomor halaman, posisi scroll) tidak hilang saat pindah tab.
      body: IndexedStack(
        index: selectedIndex,
        children: const [SearchPage(), FavoritesPage()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Cari'),
          NavigationDestination(
            icon: Icon(Icons.video_collection_sharp),
            label: 'Koleksi',
          ),
        ],
      ),
    );
  }
}
