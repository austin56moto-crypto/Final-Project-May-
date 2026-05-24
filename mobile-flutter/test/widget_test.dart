// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:interntask_ai_cloud/main.dart';

void main() {
  testWidgets('signs in and opens the portal', (WidgetTester tester) async {
    await tester.pumpWidget(const InternTaskApp());
    await tester.pumpAndSettle();

    expect(find.text('Sign in to your portal'), findsOneWidget);
    expect(find.text('Enter portal'), findsOneWidget);

    await tester.ensureVisible(find.text('Enter portal'));
    await tester.tap(find.text('Enter portal'));
    await tester.pumpAndSettle();

    expect(find.text('Live Tasks'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });
}
