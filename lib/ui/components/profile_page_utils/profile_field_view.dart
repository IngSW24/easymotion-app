import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Theme/theme.dart';
import 'field_descriptor.dart';

class ProfileFieldView extends StatelessWidget {
  const ProfileFieldView({
    super.key,
    required this.definition,
    required this.dataSource,
  });

  final FieldDefinition definition;
  final Map<String, dynamic> dataSource;

  String? _getDisplayValue(dynamic raw, BuildContext context) {
    if (raw == null || raw.toString().isEmpty) {
      return '—';
    }

    switch (definition.type) {
      case FieldDataType.string:
        if (raw.toString() == "MALE") return "Maschio";
        if (raw.toString() == "FEMALE") return "Femmina";
        if (raw.toString() == "OTHER") {
          return "Altro / Preferisco non specificare";
        }
        if (raw.toString() == "LOW") return "Base";
        if (raw.toString() == "MEDIUM") return "Intermedio";
        if (raw.toString() == "HIGH") return "Avanzato";
        if (raw.toString() == "LIMITED") return "Basso";
        if (raw.toString() == "MODERATE") return "Moderato";
        if (raw.toString() == "FULL") return "Totale";
        return raw.toString();

      case FieldDataType.number:
        final num n = raw as num;
        final str = n.toStringAsFixed(definition.decimals ?? 0);
        return definition.unit != null ? '$str ${definition.unit}' : str;

      case FieldDataType.date:
        final locale = Localizations.localeOf(context).languageCode;
        final dateFmt = DateFormat.yMMMMd(locale);
        return dateFmt.format(DateTime.parse(raw.toString()));

      case FieldDataType.boolean:
        return raw.toString() == "true" ? "Sì" : "No";
    }
  }

  @override
  Widget build(BuildContext context) {
    final raw = dataSource[definition.key];
    final display = _getDisplayValue(raw, context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7,
            child: Text(
              definition.label,
              style: DesignTokens.label,
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              display!,
              style: DesignTokens.value,
            ),
          ),
        ],
      ),
    );
  }
}
