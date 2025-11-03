import 'package:flutter_test/flutter_test.dart';

import 'package:memory_card_flip_game/models/game_state.dart';

void main() {
  testWidgets('Game state initializes with correct number of cards', (
    WidgetTester tester,
  ) async {
    final gameState = GameState();

    // Verify that we have 16 cards (8 pairs)
    expect(gameState.cards.length, equals(16));

    // Verify initial state
    expect(gameState.score, equals(0));
    expect(gameState.moves, equals(0));
    expect(gameState.gameStarted, equals(false));
    expect(gameState.gameWon, equals(false));

    // Verify cards have unique IDs
    final ids = gameState.cards.map((card) => card.id).toList();
    expect(ids.toSet().length, equals(16));

    // Clean up
    gameState.dispose();
  });

  testWidgets('Game logic correctly identifies matches', (
    WidgetTester tester,
  ) async {
    final gameState = GameState();

    // Find two cards with the same icon (a pair)
    for (int i = 0; i < gameState.cards.length; i++) {
      final card1 = gameState.cards[i];
      for (int j = i + 1; j < gameState.cards.length; j++) {
        final card2 = gameState.cards[j];
        if (card1.icon == card2.icon && !card1.isMatched && !card2.isMatched) {
          // Flip both cards
          gameState.flipCard(i);
          gameState.flipCard(j);

          // Verify they are matched
          expect(gameState.cards[i].isMatched, isTrue);
          expect(gameState.cards[j].isMatched, isTrue);

          // Clean up and exit
          gameState.dispose();
          return;
        }
      }
    }

    // If we get here, all cards are already matched somehow
    gameState.dispose();
  });
}
