import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Theme/Theme.dart';
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
    final locale  = Localizations.localeOf(context).languageCode;
    final dateFmt = DateFormat.yMMMMd(locale);
    final raw     = dataSource[definition.key];

    String display;
    if (raw == null) {
      display = '—';
    } else {
      switch (definition.type) {
        case FieldDataType.string:
          display = raw.toString();
          break;
        case FieldDataType.number:
          final num n = raw as num;
          final str = n.toStringAsFixed(definition.decimals ?? 0);
          display = definition.unit != null ? '$str ${definition.unit}' : str;
          break;
        case FieldDataType.date:
          display = dateFmt.format(DateTime.parse(raw.toString()));
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
