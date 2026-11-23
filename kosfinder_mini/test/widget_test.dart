// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kosfinder_mini/main.dart';

void main() {
  testWidgets('Menampilkan dan mencari enam kos', (WidgetTester tester) async {
    await tester.pumpWidget(const KosFinderApp());

    expect(find.text('KosFinder Mini'), findsOneWidget);
    expect(find.text('Kos Melati'), findsOneWidget);
    expect(KosListPage.kosList, hasLength(6));

    await tester.enterText(find.byType(TextField), 'MELATI');
    await tester.pump();
    expect(find.text('Kos Melati'), findsOneWidget);
    expect(find.text('Kos Mawar'), findsNothing);

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();
    expect(find.text('Kos Mawar'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Bougenville');
    await tester.pump();
    expect(find.text('Rp 1.350.000 / bulan'), findsOneWidget);
  });

  testWidgets('Favorit dan empty state bekerja', (WidgetTester tester) async {
    await tester.pumpWidget(const KosFinderApp());

    expect(find.byIcon(Icons.favorite_border), findsWidgets);
    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Mawar');
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Melati');
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Tidak ada');
    await tester.pump();
    expect(find.text('Kos tidak ditemukan'), findsOneWidget);
  });
}
