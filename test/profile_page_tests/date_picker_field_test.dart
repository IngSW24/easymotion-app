import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/ui/components/utility/date_picker_field.dart';

void main() {
  group('DatePickerField', () {
    late TextEditingController controller;

    setUp(() {
      controller = TextEditingController();
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('displays label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('Data nascita'), findsOneWidget);
    });

    testWidgets('shows calendar icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('is read-only', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.readOnly, isTrue);
    });

    testWidgets('displays initial value correctly',
        (WidgetTester tester) async {
      controller.text = '2023-01-01';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.text('2023-01-01'), findsOneWidget);
    });

    testWidgets('shows disabled state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
              enabled: false,
            ),
          ),
        ),
      );

      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, isFalse);
    });

    testWidgets('opens date picker on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // The date picker should be shown
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('updates controller when date is selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DatePickerField(
              label: 'Data nascita',
              controller: controller,
            ),
          ),
        ),
      );

      // Open date picker
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();

      // Seleziona una data specifica (1 gennaio 2023)
      await tester.tap(find.text('1')); // Seleziona il giorno
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verifica che il controller contenga una data valida
      expect(controller.text, isNotEmpty);
      expect(controller.text, matches(r'^\d{4}-\d{2}-\d{2}$'));
    });
  });
}
