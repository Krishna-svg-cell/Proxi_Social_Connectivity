import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dual_mode_app/main.dart';
import 'package:dual_mode_app/app_state.dart';

void main() {
  testWidgets('Auth Screen Smoke Test', (WidgetTester tester) async {
    // 1. Build the app (We must wrap it in Provider because main.dart does that)
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => AppState())],
        child: const MyApp(),
      ),
    );

    // 2. Verify that the Auth Screen loads correctly
    expect(find.text('Proxi'), findsOneWidget); // Checks for Title
    expect(find.text('Enter App'), findsOneWidget); // Checks for Button
  });
}