import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'profile_page_tests/profile_edit_controller_test.dart'
    as controller_test;
import 'profile_page_tests/field_builder_test.dart' as field_builder_test;
import 'profile_page_tests/profile_field_view_test.dart' as field_view_test;
import 'profile_page_tests/date_picker_field_test.dart' as date_picker_test;
import 'profile_page_tests/profile_avatar_test.dart' as avatar_test;
import 'profile_page_tests/section_card_test.dart' as section_card_test;

void main() {
  group('Profile Page Test Suite', () {
    // Run controller tests first as they are the foundation
    group('ProfileEditController Tests', () {
      controller_test.main();
    });

    // Run field builder tests next as they depend on the controller
    group('FieldBuilder Tests', () {
      field_builder_test.main();
    });

    // Run field view tests
    group('ProfileFieldView Tests', () {
      field_view_test.main();
    });

    // Run date picker tests
    group('DatePickerField Tests', () {
      date_picker_test.main();
    });

    // Run avatar tests
    group('ProfileAvatar Tests', () {
      avatar_test.main();
    });

    // Run section card tests
    group('SectionCard Tests', () {
      section_card_test.main();
    });
  });
}
