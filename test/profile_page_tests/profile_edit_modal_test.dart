import 'package:easymotion_app/api-client-generated/api_schema.enums.swagger.dart'
    as enums;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/field_descriptor.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/user_profile_modal/profile_edit_modal.dart';

/**
class _FakePatient {
  final query = _FakeQuery();
  final update = _FakeUpdate();
}

class _FakeQuery {
  final data = null; // oppure un AuthUserDto finto se serve
  bool get isLoading => false;
  Future<void> refetch() async {}
}

class _FakeUpdate {
  Future<void> mutate(dynamic _) async {}
}
 */

void main() {
  late AuthUserDto initialData;
  late List<FieldDefinition> schema;

  setUp(() {
    schema = [
      FieldDefinition(
        key: 'firstName',
        label: 'Nome',
        type: FieldDataType.string,
        location: FieldLocation.root,
      ),
      FieldDefinition(
        key: 'height',
        label: 'Altezza',
        type: FieldDataType.number,
        unit: 'cm',
        location: FieldLocation.patient,
      ),
      FieldDefinition(
        key: 'email',
        label: 'Email',
        type: FieldDataType.string,
        location: FieldLocation.root,
      ),
    ];

    initialData = AuthUserDto(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      role: enums.AuthUserDtoRole.user,
      isEmailVerified: true,
      twoFactorEnabled: false,
      patient: PatientDto(
        userId: '1',
        height: 180,
      ),
    );
  });

  group('EditModalProfile', () {
    testWidgets('displays modal title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      expect(find.text('Modifica Profilo'), findsOneWidget);
    });

    testWidgets('displays all fields from schema', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Altezza'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('shows disabled state for email field',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      final emailField = find.byType(TextFormField).at(2); // Email field
      final textField = tester.widget<TextFormField>(emailField);
      expect(textField.enabled, isFalse);
    });

/**
    testWidgets('shows save button', (WidgetTester tester) async {
      final fakeUser = initialData;
      final fakePatient = _FakePatient();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      expect(find.text('Save'), findsOneWidget);
    });
*/
    testWidgets('shows loading state when saving', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      // Tap save button
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Should show loading state
      expect(find.text('Saving…'), findsOneWidget);
    });

    testWidgets('validates form before saving', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      // Clear required field
      await tester.enterText(find.byType(TextFormField).first, '');

      // Try to save
      await tester.tap(find.text('Save'));
      await tester.pump();

      // Should show validation error
      expect(find.text('Campo obbligatorio'), findsOneWidget);
    });

    testWidgets('handles keyboard properly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EditModalProfile(
              title: 'Modifica Profilo',
              schema: schema,
              initialData: initialData,
            ),
          ),
        ),
      );

      final textFields = find.byType(TextFormField);
      expect(textFields, findsWidgets); // Assicura che ci sia almeno uno
      final textFieldFinder = textFields.first;
      await tester.tap(textFieldFinder);
      await tester.pump();

      // Verifica che il campo abbia il focus
      final textFieldElement = tester.element(textFieldFinder);
      final focusNode = Focus.of(textFieldElement);
      expect(focusNode.hasFocus, isTrue);

      // Dismiss keyboard by tapping outside
      await tester.tapAt(const Offset(1, 1)); // Tap fuori dal campo
      await tester.pump();

      // Verifica che il campo abbia perso il focus
      expect(focusNode.hasFocus, isFalse);
    });
  });
}
