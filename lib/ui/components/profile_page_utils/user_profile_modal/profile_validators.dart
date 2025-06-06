class ProfileValidators {
  /// Validates a required text field
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Questo campo è obbligatorio';
    }
    return null;
  }

  /// Validates a phone number
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) return null;
    final phoneRegex = RegExp(r'^\+?[0-9]{12}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s+'), ''))) {
      return 'Inserisci un numero di telefono valido';
    }
    return null;
  }

  /// Validates a number field with optional min/max constraints
  static String? number(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) return null;
    final number = double.tryParse(value);
    if (number == null) {
      return 'Inserisci un numero valido';
    }
    if (min != null && number < min) {
      return 'Il valore deve essere maggiore di $min';
    }
    if (max != null && number > max) {
      return 'Il valore deve essere minore di $max';
    }
    return null;
  }

  /// Validates height (in cm)
  static String? height(String? value) {
    return number(value, min: 50, max: 250);
  }

  /// Validates weight (in kg)
  static String? weight(String? value) {
    return number(value, min: 40, max: 400);
  }

  /// Validates blood pressure in format "systolic/diastolic"
  static String? bloodPressure(String? value) {
    if (value == null || value.isEmpty) return null;
    final parts = value.split('/');
    if (parts.length != 2) {
      return 'Formato non valido (es. 120/80)';
    }

    final systolic = int.tryParse(parts[0]);
    final diastolic = int.tryParse(parts[1]);

    if (systolic == null || diastolic == null) {
      return 'Inserisci valori numerici validi';
    }

    if (systolic < 60 || systolic > 250) {
      return 'Valore sistolico non valido';
    }

    if (diastolic < 40 || diastolic > 150) {
      return 'Valore diastolico non valido';
    }

    if (systolic <= diastolic) {
      return 'La pressione sistolica deve essere maggiore della diastolica';
    }

    return null;
  }

  /// Validates resting heart rate (bpm)
  static String? restingHeartRate(String? value) {
    return number(value, min: 30, max: 200);
  }

  /// Validates sleep hours
  static String? sleepHours(String? value) {
    return number(value, min: 0, max: 24);
  }

  /// Validates alcohol units per week
  static String? alcoholUnits(String? value) {
    return number(value, min: 0, max: 100);
  }
}
