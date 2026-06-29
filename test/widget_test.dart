import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:encourage/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EncourageApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
