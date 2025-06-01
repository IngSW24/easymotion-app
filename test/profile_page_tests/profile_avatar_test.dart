import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easymotion_app/ui/components/profile_page_utils/profile_avatar.dart';

void main() {
  group('ProfileAvatar', () {
    testWidgets('displays avatar with correct dimensions',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final boxConstraints = container.constraints as BoxConstraints;

      expect(boxConstraints.maxWidth, equals(120));
      expect(boxConstraints.maxHeight, equals(120));
    });

    testWidgets('displays person icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.person));
      expect(icon.size, equals(60));
      expect(icon.color, equals(Colors.white));
    });

    testWidgets('has circular shape', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, equals(BoxShape.circle));
    });

    testWidgets('has grey background color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(Colors.grey));
    });

    testWidgets('centers content', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ProfileAvatar(),
          ),
        ),
      );

      final avatarFinder = find.byType(ProfileAvatar);
      expect(avatarFinder, findsOneWidget);

      // Accetta almeno un Center discendente
      final center = find.descendant(
        of: avatarFinder,
        matching: find.byType(Center),
      );
      expect(center, findsAtLeastNWidgets(1));
    });
  });
}
