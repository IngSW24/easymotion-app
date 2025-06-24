import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utility/date_picker_field.dart';
import 'profile_edit_controller.dart';
import '../field_descriptor.dart';
import 'profile_validators.dart';

/// Costruisce dinamicamente i campi del profilo a partire da una [FieldDefinition].
/// Alcuni controlli personalizzati (slider, dropdown, switch) sono gestiti qui.
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
    // --- Chiavi custom -------------------------------------------------------------------------

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
              value: 'OTHER',
              child: Text('Altro / Preferisco non specificare')),
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
          DropdownMenuItem(value: 'LOW', child: Text('Base')),
          DropdownMenuItem(value: 'MEDIUM', child: Text('Intermedio')),
          DropdownMenuItem(value: 'HIGH', child: Text('Avanzato')),
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
          DropdownMenuItem(value: 'LIMITED', child: Text('Basso')),
          DropdownMenuItem(value: 'MODERATE', child: Text('Moderato')),
          DropdownMenuItem(value: 'FULL', child: Text('Totale')),
        ],
        onChanged: (v) {
          controller.textCtrls['mobilityLevel']!.text = v ?? '';
        },
      );
    }

    if (def.key == 'smoker') {
      return ValueListenableBuilder<bool>(
        valueListenable: controller.smokerNotifier,
        builder: (_, isSmoker, __) => SwitchListTile(
          title: const Text('Fumatore'),
          value: isSmoker,
          onChanged: (v) => controller.smokerNotifier.value = v,
        ),
      );
    }

    // Nuovo: sportFrequency (0–7) ---------------------------------------------------------------
    if (def.key == 'sportFrequency') {
      return StatefulBuilder(
        builder: (context, setState) {
          double current = double.tryParse(
                controller.textCtrls['sportFrequency']!.text,
              ) ??
              0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Frequenza attività sportiva: ${current.round()} volte/settimana'),
              Slider.adaptive(
                min: 0,
                max: 7,
                divisions: 7,
                label: current.round().toString(),
                value: current,
                onChanged: (v) {
                  setState(() {});
                  controller.textCtrls['sportFrequency']!.text =
                      v.round().toString();
                },
              ),
            ],
          );
        },
      );
    }

    // Nuovo: painIntensity (0–4) ----------------------------------------------------------------
    if (def.key == 'painIntensity') {
      return StatefulBuilder(
        builder: (context, setState) {
          double current = double.tryParse(
                controller.textCtrls['painIntensity']!.text,
              ) ??
              0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Intensità del dolore: ${current.round()}'),
              Slider.adaptive(
                min: 0,
                max: 4,
                divisions: 4,
                label: current.round().toString(),
                value: current,
                onChanged: (v) {
                  setState(() {});
                  controller.textCtrls['painIntensity']!.text =
                      v.round().toString();
                },
              ),
            ],
          );
        },
      );
    }

    // Nuovo: painFrequency dropdown --------------------------------------------------------------
    if (def.key == 'painFrequency') {
      return DropdownButtonFormField<String>(
        value: controller.textCtrls['painFrequency']!.text.isEmpty
            ? null
            : controller.textCtrls['painFrequency']!.text,
        decoration: const InputDecoration(
          labelText: 'Frequenza del dolore',
          border: OutlineInputBorder(),
        ),
        items: const [
          DropdownMenuItem(
              value: 'Intermittente', child: Text('Intermittente')),
          DropdownMenuItem(value: 'Continuo', child: Text('Continuo')),
          DropdownMenuItem(value: 'Notturno', child: Text('Notturno')),
        ],
        onChanged: (v) {
          controller.textCtrls['painFrequency']!.text = v ?? '';
        },
      );
    }

    // Nuovo: perceivedStress slider (0–10) -------------------------------------------------------
    if (def.key == 'perceivedStress') {
      return StatefulBuilder(
        builder: (context, setState) {
          double current = double.tryParse(
                controller.textCtrls['perceivedStress']!.text,
              ) ??
              0;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Stress percepito: ${current.round()} / 10'),
              Slider.adaptive(
                min: 0,
                max: 10,
                divisions: 10,
                label: current.round().toString(),
                value: current,
                onChanged: (v) {
                  setState(() {});
                  controller.textCtrls['perceivedStress']!.text =
                      v.round().toString();
                },
              ),
            ],
          );
        },
      );
    }

    // Nuovo: bloodPressure (validazione 120/80) --------------------------------------------------
    if (def.key == 'bloodPressure') {
      return TextFormField(
        controller: controller.textCtrls['bloodPressure'],
        decoration: const InputDecoration(
          labelText: 'Pressione sanguigna (sistolica/diastolica)',
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.text, // tastiera con lo slash
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
        ],
        validator: _getValidatorForField('bloodPressure'),
      );
    }

    // --- Campi standard -------------------------------------------------------------------------
    switch (def.type) {
      case FieldDataType.string:
        if (def.key == 'phoneNumber') {
          return TextFormField(
            controller: controller.textCtrls['phoneNumber'],
            decoration: InputDecoration(
              labelText: 'Telefono',
              border: const OutlineInputBorder(),
              prefixIcon: CountryCodePicker(
                onChanged: (countryCode) {
                  // Aggiorna il prefisso nel controller
                  final currentText = controller.textCtrls['phoneNumber']!.text;
                  final number = currentText.contains('+')
                      ? currentText.substring(currentText.indexOf(' ') + 1)
                      : currentText;
                  controller.textCtrls['phoneNumber']!.text =
                      '${countryCode.dialCode} $number';
                },
                initialSelection: 'IT',
                favorite: const ['IT', 'US', 'FR', 'DE'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: _getValidatorForField('phoneNumber'),
          );
        } else {
          return TextFormField(
            controller: controller.textCtrls[def.key],
            decoration: InputDecoration(
              labelText: def.label,
              border: const OutlineInputBorder(),
            ),
            enabled: def.key != 'email',
            validator: _getValidatorForField(def.key),
          );
        }

      case FieldDataType.number:
        return TextFormField(
          controller: controller.textCtrls[def.key],
          decoration: InputDecoration(
            labelText:
                def.unit != null ? '${def.label} (${def.unit})' : def.label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: _getValidatorForField(def.key),
        );

      case FieldDataType.date:
        return DatePickerField(
          label: def.label,
          controller: controller.textCtrls[def.key]!,
          enabled: def.key != 'lastMedicalCheckup',
        );
      case FieldDataType.boolean:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String? Function(String?)? _getValidatorForField(String key) {
    switch (key) {
      case 'firstName':
        return ProfileValidators.required;
      case 'lastName':
        return ProfileValidators.required;
      case 'phoneNumber':
        return ProfileValidators.phoneNumber;
      case 'height':
        return ProfileValidators.height;
      case 'weight':
        return ProfileValidators.weight;
      case 'bloodPressure':
        return ProfileValidators.bloodPressure;
      case 'restingHeartRate':
        return ProfileValidators.restingHeartRate;
      case 'sleepHours':
        return ProfileValidators.sleepHours;
      case 'alcoholUnits':
        return ProfileValidators.alcoholUnits;
      default:
        return null;
    }
  }
}
