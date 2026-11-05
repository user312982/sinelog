import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sinelog/main.dart';

void main() {
  testWidgets('cari film, tambah ke koleksi, lalu hapus', (tester) async {
    await tester.pumpWidget(const MyApp());

    // Mencari Film
    await tester.enterText(find.byType(SearchBar), 'parasite');
    await tester.pump();
    expect(find.text('Parasite'), findsOneWidget);
    expect(find.text('Inception'), findsNothing);

    // Menambah film ke koleksi
    await tester.tap(find.byIcon(Icons.bookmark_outline));
    await tester.pump();

    // Melihat koleksi film
    await tester.tap(find.text('Collection'));
    await tester.pumpAndSettle();
    expect(find.text('Parasite'), findsOneWidget);

    // Mengubah rating film
    await tester.tap(find.byIcon(Icons.star_border).at(2));
    await tester.pump();
    expect(find.text('Rating saya: 3/5'), findsOneWidget);

    // Menghapus film
    await tester.tap(find.byIcon(Icons.bookmark));
    await tester.pump();
    expect(find.text('Parasite'), findsNothing);
  });
}
