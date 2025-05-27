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

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat.yMMMMd(locale);
    final raw = dataSource[definition.key];

    String display = "";
    if (raw == null) {
      display = '—';
    } else {
      switch (definition.type) {
        case FieldDataType.string:
          if (raw.toString() == "MALE") {
            display = "Maschio";
          } else if (raw.toString() == "FEMALE") {
            display = "Femmina";
          } else if (raw.toString() == "OTHER") {
            display = "Altro / Preferisco non specificare";
          } else if (raw.toString() == "LOW") {
            display = "Base";
          } else if (raw.toString() == "MEDIUM") {
            display = "Intermedio";
          } else if (raw.toString() == "HIGH") {
            display = "Avanzato";
          } else if (raw.toString() == "LIMITED") {
            display = "Basso";
          } else if (raw.toString() == "MODERATE") {
            display = "Moderato";
          } else if (raw.toString() == "FULL") {
            display = "Totale";
          } else {
            display = raw.toString();
          }
          break;
        case FieldDataType.number:
          final num n = raw as num;
          final str = n.toStringAsFixed(definition.decimals ?? 0);
          display = definition.unit != null ? '$str ${definition.unit}' : str;
          break;
        case FieldDataType.date:
          display = dateFmt.format(DateTime.parse(raw.toString()));
          break;
        case FieldDataType.boolean:
          display = raw.toString();
          break;
      }
    }

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
              display,
              style: DesignTokens.value,
            ),
          ),
        ],
      ),
    );
  }
}
