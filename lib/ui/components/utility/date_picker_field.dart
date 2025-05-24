import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class DatePickerField extends HookWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final dateFormatter = DateFormat('yyyy-MM-dd', locale.toString());

    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime initial = DateTime.now();
        if (controller.text.isNotEmpty) {
          try {
            initial = dateFormatter.parse(controller.text);
          } catch (_) {
            final parsed = DateTime.tryParse(controller.text);
            if (parsed != null) initial = parsed;
          }
        }

        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          locale: locale,
        );

        if (picked != null) {
          controller.text = dateFormatter.format(picked);
        }
      },
    );
  }
}
