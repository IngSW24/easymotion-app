import 'package:easymotion_app/ui/components/courses/course_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const List<String> testCategoriesListExtended = [
    "CROSSFIT",
    "ZUMBA_FITNESS",
    "BODYWEIGHT_WORKOUT"
  ];
  const List<String> testLevelsListExtended = ["MEDIUM", "ADVANCED"];
  const List<String> testFrequenciesListExtended = ["WEEKLY", "MONTHLY"];
  const List<String> testAvailabilitiesListExtended = [
    "ACTIVE",
    "NO_LONGER_AVAILABLE"
  ];

  testWidgets('Course filter test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: CourseFilter(
      selectedCategories: testCategoriesListExtended,
      selectedLevels: testLevelsListExtended,
      selectedFrequencies: testFrequenciesListExtended,
      selectedAvailabilities: testAvailabilitiesListExtended,
      onCategoriesChanged: (List<String> a) {},
      onLevelsChanged: (List<String> a) {},
      onFrequenciesChanged: (List<String> a) {},
      onAvailabilitiesChanged: (List<String> a) {},
    ))));

    for (var item in testCategoriesListExtended) {
      final itemFinder = find.text(CourseFilter.categories[item]!);
      await tester.scrollUntilVisible(itemFinder, 100);
      expect(itemFinder, findsOneWidget);
    }
    for (var item in testLevelsListExtended) {
      final itemFinder = find.text(CourseFilter.levels[item]!);
      await tester.scrollUntilVisible(itemFinder, 100);
      expect(itemFinder, findsOneWidget);
    }
    for (var item in testFrequenciesListExtended) {
      final itemFinder = find.text(CourseFilter.frequencies[item]!);
      await tester.scrollUntilVisible(itemFinder, 100);
      expect(itemFinder, findsOneWidget);
    }
    for (var item in testAvailabilitiesListExtended) {
      final itemFinder = find.text(CourseFilter.availabilities[item]!);
      await tester.scrollUntilVisible(itemFinder, 100);
      expect(itemFinder, findsOneWidget);
    }
  });
}
