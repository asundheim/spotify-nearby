import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_nearby/pages/settings.dart';
void main() {
  testWidgets('theme list should populate correctly', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Settings()
    ));
    await tester.tap(find.byIcon(Icons.color_lens));
    await tester.pumpAndSettle();
    expect(find.text('Blue'), findsOneWidget);
    expect(find.text('Green'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);
    expect(find.text('Yellow'), findsOneWidget);
    expect(find.text('Pink'), findsOneWidget);
    expect(find.text('Purple'), findsOneWidget);
    expect(find.text('Cyan'), findsOneWidget);
  });
}