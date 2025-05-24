import 'package:flutter/material.dart';
import '../../utility/date_picker_field.dart';
import 'profile_edit_controller.dart';
import '../field_descriptor.dart';

class FieldBuilder extends StatelessWidget {
  const FieldBuilder({
    super.key,
    required this.controller,
    required this.def,
  });

  final ProfileEditController controller;
  final FieldDefinition def;

  @override
  Widget build(BuildContext context) {
    if (def.key == 'sex') {
      return DropdownButtonFormField<String>(
        value: controller.textCtrls['sex']!.text.isEmpty
            ? null
            : controller.textCtrls['sex']!.text,
        decoration: const InputDecoration(
          labelText: 'Sesso',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'MALE', child: Text('Maschio')),
          DropdownMenuItem(value: 'FEMALE', child: Text('Femmina')),
          DropdownMenuItem(
            value: 'Other',
            child: Text('Altro / Preferisco non specificare'),
          ),
        ],
        onChanged: (v) {
          controller.textCtrls['sex']!.text = v ?? '';
        },
      );
    }

    if (def.key == 'activityLevel') {
      return DropdownButtonFormField<String>(
        value: controller.textCtrls['activityLevel']!.text.isEmpty
            ? null
            : controller.textCtrls['activityLevel']!.text,
        decoration: const InputDecoration(
          labelText: 'Livello attività sportiva',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Base', child: Text('Base')),
          DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
          DropdownMenuItem(value: 'Avanzato', child: Text('Avanzato')),
        ],
        onChanged: (v) {
          controller.textCtrls['activityLevel']!.text = v ?? '';
        },
      );
    }

    if (def.key == 'mobilityLevel') {
      return DropdownButtonFormField<String>(
        value: controller.textCtrls['mobilityLevel']!.text.isEmpty
            ? null
            : controller.textCtrls['mobilityLevel']!.text,
        decoration: const InputDecoration(
          labelText: 'Livello di mobilità',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(value: 'Basso', child: Text('Basso')),
          DropdownMenuItem(value: 'Moderato', child: Text('Moderato')),
          DropdownMenuItem(value: 'Totale', child: Text('Totale')),
        ],
        onChanged: (v) {
          controller.textCtrls['mobilityLevel']!.text = v ?? '';
        },
      );
    }

    if (def.key == 'smoker') {
      return ValueListenableBuilder<bool>(
        valueListenable: controller.smokerNotifier,
        builder: (_, isSmoker, __) {
          return SwitchListTile(
            title: const Text('Smoker'),
            value: isSmoker,
            onChanged: (v) => controller.smokerNotifier.value = v,
          );
        },
      );
    }

    // Standard fields
    switch (def.type) {
      case FieldDataType.string:
        return TextFormField(
          controller: controller.textCtrls[def.key],
          decoration: InputDecoration(
            labelText: def.label,
            border: const OutlineInputBorder(),
          ),
          maxLines: def.key == 'notes' || def.key == 'personalGoals' ? 4 : 1,
        );
      case FieldDataType.number:
        return TextFormField(
          controller: controller.textCtrls[def.key],
          decoration: InputDecoration(
            labelText: def.unit != null
                ? '${def.label} (${def.unit})'
                : def.label,
            border: const OutlineInputBorder(),
          ),
          keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
        );
      case FieldDataType.date:
        return DatePickerField(
          label: def.label,
          controller: controller.textCtrls[def.key]!,
        );
    }
  }
}
