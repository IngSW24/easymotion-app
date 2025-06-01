import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class DatePickerField extends HookWidget {
  const DatePickerField({
    super.key,
    required this.label,
    required this.controller,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final dateFormatter = DateFormat('yyyy-MM-dd', locale.toString());

    return TextFormField(
      controller: controller,
      readOnly: true,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
        filled: !enabled,
        fillColor: !enabled ? Colors.grey[200] : null,
      ),
      onTap: enabled
          ? () async {
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
            }
          : null,
    );
  }
}
