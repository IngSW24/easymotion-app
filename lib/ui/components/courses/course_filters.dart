import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CourseFilter extends StatelessWidget {
  const CourseFilter(
      {super.key,
      required this.selectedCategories,
      required this.selectedLevels,
      required this.onCategoriesChanged,
      required this.onLevelsChanged});

  final List<String> selectedCategories, selectedLevels;
  final void Function(List<String>) onCategoriesChanged, onLevelsChanged;

  static const Map<String, String> categories = {
    "ACQUAGYM": "Acquagym",
    "CROSSFIT": "Crossfit",
    "PILATES": "Pilates",
    "ZUMBA_FITNESS": "Zumba Fitness",
    "POSTURAL_TRAINING": "Training Posturale",
    "BODYWEIGHT_WORKOUT": "Workout Corpo Libero"
  };
  static const Map<String, String> levels = {
    "BASIC": "Base",
    "MEDIUM": "Intermedio",
    "ADVANCED": "Avanzato"
  };

  @override
  Widget build(BuildContext context) {
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
          Column(
              children: categories.entries.map((entry) {
            return CheckboxListTile(
                title: Text(entry.value),
                value: selectedCategories.contains(entry.key),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onCategoriesChanged(selectedCategories + [entry.key]);
                  } else {
                    selectedCategories.remove(entry.key);
                    onCategoriesChanged(selectedCategories);
                  }
                });
          }).toList()),
          Text("Livelli di difficoltà"),
          Column(
              children: levels.entries.map((entry) {
            return CheckboxListTile(
                title: Text(entry.value),
                value: selectedLevels.contains(entry.key),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onLevelsChanged(selectedLevels + [entry.key]);
                  } else {
                    selectedLevels.remove(entry.key);
                    onLevelsChanged(selectedLevels);
                  }
                });
          }).toList()),
          SizedBox(
            height: 12,
          ),
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
