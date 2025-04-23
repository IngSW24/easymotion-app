import 'package:easymotion_app/data/hooks/use_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class CourseFilter extends HookWidget {
  const CourseFilter(
      {super.key,
      required this.selectedCategories,
      required this.selectedLevels,
      required this.onCategoriesChanged,
      required this.onLevelsChanged});

  final List<String> selectedCategories, selectedLevels;
  final void Function(List<String>) onCategoriesChanged, onLevelsChanged;

  static const Map<String, String> levels = {
    "BASIC": "Base",
    "MEDIUM": "Intermedio",
    "ADVANCED": "Avanzato"
  };

  @override
  Widget build(BuildContext context) {
    final categories = useCategories(context).data;

    if (categories == null) return SizedBox();

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
              children: categories.map((category) {
            return CheckboxListTile(
                title: Text(category.name),
                value: selectedCategories.contains(category.id),
                onChanged: (bool? selected) {
                  if (selected != null && selected) {
                    onCategoriesChanged(selectedCategories + [category.id]);
                  } else {
                    selectedCategories.remove(category.id);
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
