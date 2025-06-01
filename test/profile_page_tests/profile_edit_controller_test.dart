import 'package:easymotion_app/api-client-generated/api_schema.enums.swagger.dart'
    as enums;
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/api-client-generated/api_schema.models.swagger.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/field_descriptor.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/user_profile_modal/profile_edit_controller.dart';

void main() {
  late ProfileEditController controller;
  late List<FieldDefinition> schema;
  late AuthUserDto initialData;

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
        key: 'birthDate',
        label: 'Data nascita',
        type: FieldDataType.date,
        location: FieldLocation.root,
      ),
    ];

    initialData = AuthUserDto(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      birthDate: '1990-01-01',
      patient: PatientDto(
        height: 180,
        userId: '1',
      ),
      role: enums.AuthUserDtoRole.user,
      isEmailVerified: true,
      twoFactorEnabled: false,
    );

    controller = ProfileEditController(
      schema: schema,
      initialData: initialData,
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('ProfileEditController', () {
    test('initializes controllers with correct initial values', () {
      expect(controller.textCtrls['firstName']!.text, equals('John'));
      expect(controller.textCtrls['height']!.text, equals('180'));
      expect(controller.textCtrls['birthDate']!.text, equals('1990-01-01'));
    });

    test('updates controllers with new data', () {
      final newData = AuthUserDto(
        id: '1',
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane@example.com',
        birthDate: '1992-01-01',
        patient: PatientDto(
          weight: 70,
          mobilityLevel: enums.PatientDtoMobilityLevel.moderate,
          activityLevel: enums.PatientDtoActivityLevel.medium,
          userId: '1',
        ),
        role: enums.AuthUserDtoRole.user,
        isEmailVerified: true,
        twoFactorEnabled: false,
      );

      controller.updateControllers(newData);

      expect(controller.textCtrls['firstName']!.text, equals('Jane'));
      expect(controller.textCtrls['height']!.text, equals('170'));
      expect(controller.textCtrls['birthDate']!.text, equals('1992-01-01'));
    });

    test('collects updates correctly', () {
      controller.textCtrls['firstName']!.text = 'Jane';
      controller.textCtrls['height']!.text = '170';
      controller.textCtrls['birthDate']!.text = '1992-01-01';

      final updates = controller.collectUpdates();

      expect(updates.firstName, equals('Jane'));
      expect(updates.patient?.height, equals(170));
      expect(updates.birthDate, equals('1992-01-01'));
    });

    test('handles empty values correctly', () {
      controller.textCtrls['firstName']!.text = '';
      controller.textCtrls['height']!.text = '';

      final updates = controller.collectUpdates();

      expect(updates.firstName, equals(''));
      expect(updates.patient?.height, isNull);
    });
  });
}
