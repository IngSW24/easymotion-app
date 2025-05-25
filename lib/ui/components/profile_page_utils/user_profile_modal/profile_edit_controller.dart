import 'package:easymotion_app/api-client-generated/api_schema.swagger.dart';
import 'package:flutter/material.dart';
import '../field_descriptor.dart';

class ProfileEditController {
  final List<FieldDefinition> schema;
  final AuthUserDto initialData;

  late final Map<String, TextEditingController> textCtrls;
  late final ValueNotifier<bool> smokerNotifier;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProfileEditController({
    required this.schema,
    required this.initialData,
  }) {
    // crea i text controllers solo per lo schema passato
    textCtrls = {
      for (final def in schema)
        def.key: TextEditingController(
          text: initialData.toJson()[def.key]?.toString() ?? '',
        ),
    };

    smokerNotifier = ValueNotifier<bool>(
      initialData.toJson()['smoker'] as bool? ?? false,
    );
  }

  /// Form validate
  bool validate() => formKey.currentState?.validate() ?? false;
  //final AuthUserDto updated;

  /// Collects only modified fields
  AuthUserDto collectUpdates() {
    final Map<String, dynamic> update = initialData.toJson();

    for (final def in schema) {
      final txt = textCtrls[def.key]!.text.trim();

      if (schema.length == 6) {
        final original = update[def.key]?.toString() ?? '';
        if (txt.isEmpty || txt == original) continue;

        switch (def.type) {
          case FieldDataType.string:
            update[def.key] = txt;
            break;
          case FieldDataType.number:
            update[def.key] = double.tryParse(txt);
            break;
          case FieldDataType.date:
            update[def.key] = txt;
            break;
        }
      } else {
        if (def.key == 'smoker') {
          if (smokerNotifier.value != (update['patient']['smoker'] as bool? ?? false)) {
            update['patient']['smoker'] = smokerNotifier.value;
          }
        }
        final original = update['patient'][def.key]?.toString() ?? '';
        if (txt.isEmpty || txt == original) continue;

        switch (def.type) {
          case FieldDataType.string:
            update['patient'][def.key] = txt;
            break;
          case FieldDataType.number:
            update['patient'][def.key] = double.tryParse(txt);
            break;
          case FieldDataType.date:
            update['patient'][def.key] = txt;
            break;
        }
      }

      final data = update['birthDate'];
      print("DATE: $data");
    }
    final postData = update;
    print("DOPO INITIAL DATA TO JSON $postData");

    final updated = AuthUserDto.fromJson(update);
    print(updated.toJson());
    return updated;
  }
}