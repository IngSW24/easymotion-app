import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/section_card.dart';
import 'package:easymotion_app/ui/Theme/theme.dart';

void main() {
  group('SectionCard', () {
    testWidgets('displays title and icon correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              children: const [],
            ),
          ),
        ),
      );

      expect(find.text('Test Section'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: DesignTokens.primaryBlue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              children: const [],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, equals(DesignTokens.primaryBlue));
      expect(decoration.borderRadius, equals(BorderRadius.circular(20)));

      final titleText = tester.widget<Text>(find.text('Test Section'));
      expect(titleText.style?.color, equals(Colors.white));
    });

    testWidgets('displays children correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              children: const [
                Text('Child 1'),
                Text('Child 2'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('shows edit button when onEdit is provided',
        (WidgetTester tester) async {
      bool editPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              onEdit: () => editPressed = true,
              children: const [],
            ),
          ),
        ),
      );

      expect(find.text('Modifica'), findsOneWidget);

      await tester.tap(find.text('Modifica'));
      await tester.pumpAndSettle();

      expect(editPressed, isTrue);
    });

    testWidgets('does not show edit button when onEdit is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              children: const [],
            ),
          ),
        ),
      );

      expect(find.text('Modifica'), findsNothing);
    });

    testWidgets('applies correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              children: const [
                Text('Test Content'),
              ],
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text('Test Section'));
      expect(titleText.style?.color, equals(Colors.white));
      expect(titleText.style?.fontWeight, equals(FontWeight.w600));

      final contentText = tester.widget<Text>(find.text('Test Content'));
      expect(
          contentText.style?.color == null ||
              contentText.style?.color == Colors.white,
          isTrue);
    });

    testWidgets('applies correct padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SectionCard(
              title: 'Test Section',
              icon: Icons.person,
              iconColor: Colors.white,
              backgroundColor: Colors.blue,
              foregroundTextColor: Colors.white,
              editButtonColor: Colors.white,
              children: const [],
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.padding, equals(const EdgeInsets.all(20)));
    });
  });
}
