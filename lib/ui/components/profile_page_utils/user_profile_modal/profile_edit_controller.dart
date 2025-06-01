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
    _initializeControllers();
  }

  void _initializeControllers() {
    textCtrls = {};
    final userData = initialData.toJson();

    for (final def in schema) {
      String? initialValue;
      final data = def.location == FieldLocation.root
          ? userData
          : userData['patient'] ?? {};

      initialValue = data[def.key]?.toString() ?? '';
      textCtrls[def.key] = TextEditingController(text: initialValue);
    }

    smokerNotifier = ValueNotifier<bool>(
      userData['patient']?['smoker'] == "true" ||
          userData['patient']?['smoker'] == true,
    );
  }

  void updateControllers(AuthUserDto newData) {
    final userData = newData.toJson();

    for (final def in schema) {
      final data = def.location == FieldLocation.root
          ? userData
          : userData['patient'] ?? {};

      final newValue = data[def.key]?.toString() ?? '';
      if (textCtrls[def.key]?.text != newValue) {
        textCtrls[def.key]?.text = newValue;
      }
    }

    final newSmokerValue = userData['patient']?['smoker'] == "true" ||
        userData['patient']?['smoker'] == true;
    if (smokerNotifier.value != newSmokerValue) {
      smokerNotifier.value = newSmokerValue;
    }
  }

  void dispose() {
    for (final controller in textCtrls.values) {
      controller.dispose();
    }
    smokerNotifier.dispose();
  }

  /// Form validate
  bool validate() => formKey.currentState?.validate() ?? false;
  //final AuthUserDto updated;

  /// Collects only modified fields
  AuthUserDto collectUpdates() {
    final Map<String, dynamic> update =
        Map<String, dynamic>.from(initialData.toJson());

    for (final def in schema) {
      final txt = textCtrls[def.key]!.text.trim();
      final data = def.location == FieldLocation.root
          ? update
          : (update['patient'] ??= {});

      // Per gli altri tipi, logica standard
      final original = data[def.key]?.toString() ?? '';
      if (txt.isEmpty && original.isEmpty) continue;
      if (txt == original) continue;

      switch (def.type) {
        case FieldDataType.string:
          data[def.key] = txt;
          break;
        case FieldDataType.date:
          data[def.key] = txt;
          break;
        case FieldDataType.boolean:
          data[def.key] = (txt.toLowerCase() == 'true');
          break;
        case FieldDataType.number:
          if (txt.isEmpty) {
            data[def.key] = null;
          } else {
            final numValue = double.tryParse(txt);
            if (numValue != null) {
              data[def.key] = numValue;
            }
          }
          break;
      }
    }
    //print('Fine Collection: $update');
    return AuthUserDto.fromJson(update);
  }
}
