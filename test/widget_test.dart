// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:doc_time/main.dart';

void main() {
  testWidgets('DocTime app navigates past splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const DocTimeApp());
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsOneWidget);
  });
}
