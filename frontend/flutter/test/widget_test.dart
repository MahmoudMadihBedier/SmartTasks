import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smart_tasks/main.dart';

void main() {
  testWidgets('MyApp has a title and starts with a home page', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    final titleFinder = find.text('Flutter Demo Home Page');
    expect(titleFinder, findsOneWidget);
  });
}