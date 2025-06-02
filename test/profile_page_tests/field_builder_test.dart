import 'package:easymotion_app/api-client-generated/api_schema.enums.swagger.dart'
    as enums;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/field_descriptor.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/user_profile_modal/field_builder.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/user_profile_modal/profile_edit_controller.dart';

void main() {
  late ProfileEditController controller;
  late AuthUserDto initialData;

  setUp(() {
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
        weight: 75,
        sex: enums.PatientDtoSex.male,
        activityLevel: enums.PatientDtoActivityLevel.medium,
        mobilityLevel: enums.PatientDtoMobilityLevel.moderate,
        smoker: false,
      ),
    );

    controller = ProfileEditController(
      schema: [
        FieldDefinition(
          key: 'firstName',
          label: 'Nome',
          type: FieldDataType.string,
          location: FieldLocation.root,
        ),
        FieldDefinition(
          key: 'sex',
          label: 'Sesso',
          type: FieldDataType.string,
          location: FieldLocation.patient,
        ),
        FieldDefinition(
          key: 'activityLevel',
          label: 'Livello attività',
          type: FieldDataType.string,
          location: FieldLocation.patient,
        ),
        FieldDefinition(
          key: 'mobilityLevel',
          label: 'Livello mobilità',
          type: FieldDataType.string,
          location: FieldLocation.patient,
        ),
        FieldDefinition(
          key: 'height',
          label: 'Altezza',
          type: FieldDataType.number,
          unit: 'cm',
          location: FieldLocation.patient,
        ),
      ],
      initialData: initialData,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('FieldBuilder', () {
    testWidgets('builds text field for string type',
        (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'firstName',
        label: 'Nome',
        type: FieldDataType.string,
        location: FieldLocation.root,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldBuilder(
              controller: controller,
              def: def,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Nome'), findsOneWidget);
    });

    testWidgets('builds dropdown for sex field', (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'sex',
        label: 'Sesso',
        type: FieldDataType.string,
        location: FieldLocation.patient,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldBuilder(
              controller: controller,
              def: def,
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Sesso'), findsOneWidget);
    });

    testWidgets('builds dropdown for activity level',
        (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'activityLevel',
        label: 'Livello attività',
        type: FieldDataType.string,
        location: FieldLocation.patient,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldBuilder(
              controller: controller,
              def: def,
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Livello attività sportiva'), findsOneWidget);
    });

    testWidgets('builds number field with unit', (WidgetTester tester) async {
      final def = FieldDefinition(
        key: 'height',
        label: 'Altezza',
        type: FieldDataType.number,
        unit: 'cm',
        location: FieldLocation.patient,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FieldBuilder(
              controller: controller,
              def: def,
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Altezza (cm)'), findsOneWidget);
    });
  });
}
