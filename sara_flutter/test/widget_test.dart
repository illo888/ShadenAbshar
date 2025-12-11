import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sara_flutter/app.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: SaraApp()));

    // Verify that splash screen appears
    await tester.pumpAndSettle();
    expect(find.text('سارا'), findsOneWidget);
  });
}
