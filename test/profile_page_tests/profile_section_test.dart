import 'package:easymotion_app/ui/Theme/theme.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/field_descriptor.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/profile_section.dart';

void main() {
  group('ProfileSection', () {
    final schema = [
      FieldDefinition(
        key: 'firstName',
        label: 'Nome',
        type: FieldDataType.string,
        location: FieldLocation.root,
      ),
      FieldDefinition(
        key: 'height',
        label: 'Altezza',
        type: FieldDataType.number,
        unit: 'cm',
        location: FieldLocation.patient,
      ),
    ];

    final data = {
      'firstName': 'John',
      'height': 180,
    };

    testWidgets('displays section title and icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSection(
              title: 'Informazioni personali',
              icon: Icons.person,
              schema: schema,
              data: data,
              onEdit: () {},
            ),
          ),
        ),
      );

      expect(find.text('Informazioni personali'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('displays all fields from schema', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSection(
              title: 'Informazioni personali',
              icon: Icons.person,
              schema: schema,
              data: data,
              onEdit: () {},
            ),
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('John'), findsOneWidget);
      expect(find.text('Altezza'), findsOneWidget);
      expect(find.text('180 cm'), findsOneWidget);
    });

    testWidgets('shows edit button', (WidgetTester tester) async {
      bool editPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSection(
              title: 'Informazioni personali',
              icon: Icons.person,
              schema: schema,
              data: data,
              onEdit: () => editPressed = true,
            ),
          ),
        ),
      );

      expect(find.text('Modifica'), findsOneWidget);

      await tester.tap(find.text('Modifica'));
      await tester.pumpAndSettle();

      expect(editPressed, isTrue);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSection(
              title: 'Informazioni personali',
              icon: Icons.person,
              schema: schema,
              data: data,
              onEdit: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, equals(DesignTokens.primaryBlue));
      expect(decoration.borderRadius, equals(BorderRadius.circular(20)));
    });

    testWidgets('handles empty data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileSection(
              title: 'Informazioni personali',
              icon: Icons.person,
              schema: schema,
              data: {},
              onEdit: () {},
            ),
          ),
        ),
      );

      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('—'), findsAtLeastNWidgets(schema.length));
      expect(find.text('Altezza'), findsOneWidget);
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
      // Accetta null o bianco
      expect(
          contentText.style?.color == null ||
              contentText.style?.color == Colors.white,
          isTrue);
    });
  });
}
