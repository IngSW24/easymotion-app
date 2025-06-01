import '../field_descriptor.dart';
import 'schemas.dart';

Map<String, dynamic> buildEmptyProfile() {
  dynamic get(FieldDefinition def) {
    switch (def.type) {
      case FieldDataType.string:
        return null;
      case FieldDataType.number:
        return null;
      case FieldDataType.date:
        return null;
      case FieldDataType.boolean:
        return false;
    }
  }

  final allDef = {...personalSchema, ...healthSchema}.toList();

  return {
    for (final def in allDef) def.key: get(def),
  };
}
