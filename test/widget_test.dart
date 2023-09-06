// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ui_kit/ui_kit.dart' as uikit;

void main() {
  late TextEditingController controller;
  late FocusNode focusNode;

  setUp(() {
    controller = TextEditingController();
    focusNode = FocusNode();
  });

  group('Example', () {
    testWidgets('CardOrPhoneInput test', (WidgetTester tester) async {
      final key = const Key('card_or_phone_input');
      final cardOrPhoneInput = find.byKey(key);

      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: uikit.RoundedContainer(
              key: key,
              child: uikit.CardOrPhoneInput(
                controller: controller,
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      );

      // Enter a text and pumpAndSettle()
      await tester.enterText(cardOrPhoneInput, '9860100122223333');
      await tester.pumpAndSettle();

      // Search for the widget by key in the tree and verify it exists.
      expect(cardOrPhoneInput, findsOneWidget);
    });
  });
}
