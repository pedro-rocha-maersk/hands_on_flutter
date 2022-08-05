// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:hands_on_flutter/main.dart';

void main() {
  test('Create New Game', () {
    var memoryGame = const MemoryGame();
    final element = memoryGame.createElement();
    final state =
        element.state as MemoryGameState; // this will set state.widget
    state.handleChoice(2);
    expect(state.choiceOne, 2);
    state.createNewGame();
    expect(state.choiceOne, -1);
  });
}
