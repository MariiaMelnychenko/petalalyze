import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:petalalyze/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PetalalyzeApp());
    await tester.pumpAndSettle();

    // Verify MaterialApp is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
