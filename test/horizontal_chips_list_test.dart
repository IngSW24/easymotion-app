import 'package:easymotion_app/ui/components/chip_list/horizontal_chips_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const List<String> labels = [
    'a3B',
    '7g',
    'XyZ12',
    'p',
    'QrStUvWxYz',
    '90',
    'lMnOp',
    'dEfGhIjKl',
  ];

  testWidgets('Horizontal chips list test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: HorizontalChipsList(labels: labels))));

    // Verify that our counter starts at 0.
    for (var label in labels) {
      expect(find.text(label), findsOneWidget);
    }
  });
}
