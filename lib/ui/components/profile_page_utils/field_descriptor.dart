enum FieldDataType { string, number, date, boolean }

enum FieldLocation { root, patient }

class FieldDefinition {
  final String key; // chiave JSON/DTO
  final String label; // etichetta visibile
  final FieldDataType type; // tipo dato (per formattazione)
  final int? decimals; // n° decimali se number
  final String? unit; // unità (es. "kg")
  final FieldLocation location;

  const FieldDefinition(
      {required this.key,
      required this.label,
      required this.type,
      this.decimals,
      this.unit,
      this.location = FieldLocation.patient});
}
