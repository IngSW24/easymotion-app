import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/field_descriptor.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/profile_field_view.dart';

void main() {
  group('ProfileFieldView', () {
    testWidgets('displays string value correctly', (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'firstName',
        label: 'Nome',
        type: FieldDataType.string,
        location: FieldLocation.root,
      );

      final dataSource = {'firstName': 'John'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileFieldView(
              definition: def,
              dataSource: dataSource,
            ),
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
    });

    testWidgets('displays number with unit correctly',
        (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'height',
        label: 'Altezza',
        type: FieldDataType.number,
        unit: 'cm',
        location: FieldLocation.patient,
      );

      final dataSource = {'height': 180};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileFieldView(
              definition: def,
              dataSource: dataSource,
            ),
          ),
        ),
      );

      expect(find.text('Altezza'), findsOneWidget);
      expect(find.text('180 cm'), findsOneWidget);
    });

    testWidgets('displays empty value as dash', (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'notes',
        label: 'Note',
        type: FieldDataType.string,
        location: FieldLocation.patient,
      );

      final dataSource = {'notes': null};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileFieldView(
              definition: def,
              dataSource: dataSource,
            ),
          ),
        ),
      );

      expect(find.text('Note'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
    });

    testWidgets('displays enum values with correct translations',
        (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'sex',
        label: 'Sesso',
        type: FieldDataType.string,
        location: FieldLocation.patient,
      );

      final dataSource = {'sex': 'MALE'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileFieldView(
              definition: def,
              dataSource: dataSource,
            ),
          ),
        ),
      );

      expect(find.text('Sesso'), findsOneWidget);
      expect(find.text('Maschio'), findsOneWidget);
    });

    testWidgets('displays date in correct format', (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'birthDate',
        label: 'Data nascita',
        type: FieldDataType.date,
        location: FieldLocation.root,
      );

      final dataSource = {'birthDate': '1990-01-01'};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileFieldView(
              definition: def,
              dataSource: dataSource,
            ),
          ),
        ),
      );

      expect(find.text('Data nascita'), findsOneWidget);
      // Note: The actual date format will depend on the locale
      expect(find.textContaining('1990'), findsOneWidget);
    });
  });
}
