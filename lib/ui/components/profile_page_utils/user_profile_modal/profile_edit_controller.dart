import 'package:flutter/material.dart';
import '../field_descriptor.dart';

class ProfileEditController {
  final List<FieldDefinition> schema;
  final Map<String, dynamic> initialData;

  late final Map<String, TextEditingController> textCtrls;
  late final ValueNotifier<bool> smokerNotifier;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ProfileEditController({
    required this.schema,
    required this.initialData,
  }) {
    textCtrls = {
      for (final def in schema)
        def.key: TextEditingController(
          text: initialData[def.key]?.toString() ?? '',
        ),
    };
    print(textCtrls);

    smokerNotifier = ValueNotifier<bool>(
      initialData['smoker'] as bool? ?? false,
    );
  }

  /// Form validate
  bool validate() => formKey.currentState?.validate() ?? false;

  /// Collects only modified fields
  Map<String, dynamic> collectUpdates() {
    final updated = <String, dynamic>{};

    // smoker
    if (smokerNotifier.value != (initialData['smoker'] as bool? ?? false)) {
      updated['smoker'] = smokerNotifier.value;
    }

    for (final def in schema) {
      if (def.key == 'smoker') continue;
      final txt = textCtrls[def.key]!.text.trim();
      final original = initialData[def.key]?.toString() ?? '';
      if (txt.isEmpty || txt == original) continue;

      switch (def.type) {
        case FieldDataType.string:
          updated[def.key] = txt;
          break;
        case FieldDataType.number:
          updated[def.key] = double.tryParse(txt);
          break;
        case FieldDataType.date:
          updated[def.key] = txt; // assume ISO-8601
          break;
      }
    }
    print(updated);
    return updated;
  }
}