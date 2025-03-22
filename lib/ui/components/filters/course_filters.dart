import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseFilter extends StatelessWidget {
  const CourseFilter(
      {super.key,
      required this.selectedCategories,
        required this.selectedLevels,
        required this.selectedFrequencies,
        required this.selectedAvailabilities,
      required this.onCategoriesChanged,
        required this.onLevelsChanged,
        required this.onFrequenciesChanged,
        required this.onAvailabilitiesChanged});

  final List<String> selectedCategories, selectedLevels, selectedFrequencies, selectedAvailabilities;
  final void Function(List<String>) onCategoriesChanged, onLevelsChanged, onFrequenciesChanged, onAvailabilitiesChanged;

  static const List<String> categories = [
    "Acquagym", "Crossfit"
  ];
  static const List<String> levels = [
    "Base", "Medio", "Avanzato"
  ];
  static const List<String> frequencies = [
    "Sessione singola", "Settimanale", "Mensile"
  ];
  static const List<String> availabilities = [
    "Attivo", "Disponibilità a breve", "Non disponibile"
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(16),
      height: 300,
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('Select filters',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Text("Categorie"),
          Column(children:
          categories.map((value) {
              return CheckboxListTile(
                title: Text(value),
                value: selectedCategories.contains(value),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onCategoriesChanged(selectedCategories + [value]);
                  } else {
                    selectedCategories.remove(value);
                    onCategoriesChanged(selectedCategories);
                  }
              });
          }).toList()),
          Text("Livelli"),
          Column(children:
          levels.map((value) {
            return CheckboxListTile(
                title: Text(value),
                value: selectedLevels.contains(value),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onLevelsChanged(selectedLevels + [value]);
                  } else {
                    selectedLevels.remove(value);
                    onLevelsChanged(selectedLevels);
                  }
                });
          }).toList()),
          Text("Frequenze"),
          Column(children:
          frequencies.map((value) {
            return CheckboxListTile(
                title: Text(value),
                value: selectedFrequencies.contains(value),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onFrequenciesChanged(selectedFrequencies + [value]);
                  } else {
                    selectedFrequencies.remove(value);
                    onFrequenciesChanged(selectedFrequencies);
                  }
                });
          }).toList()),
          Text("Disponibilità"),
          Column(children:
          availabilities.map((value) {
            return CheckboxListTile(
                title: Text(value),
                value: selectedAvailabilities.contains(value),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onAvailabilitiesChanged(selectedAvailabilities + [value]);
                  } else {
                    selectedAvailabilities.remove(value);
                    onAvailabilitiesChanged(selectedAvailabilities);
                  }
                });
          }).toList()),
          Spacer(),
          FilledButton.icon(
            onPressed: () => context.pop(),
            label: Text('Apply Filters'),
            icon: Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}
