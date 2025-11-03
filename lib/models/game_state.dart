import 'dart:async';
import 'card_model.dart';
import 'package:flutter/material.dart';

class GameState extends ChangeNotifier {
  List<CardModel> cards = [];
  int? firstCardIndex;
  int? secondCardIndex;
  bool canFlip = true;
  int score = 0;
  int moves = 0;
  Duration duration = Duration.zero;
  Timer? timer;
  bool gameStarted = false;
  bool gameWon = false;

  // Default icons for the game
  final List<IconData> _icons = [
    Icons.favorite,
    Icons.star,
    Icons.home,
    Icons.favorite_border,
    Icons.star_border,
    Icons.home_outlined,
    Icons.pets,
    Icons.beach_access,
    Icons.pets_outlined,
    Icons.beach_access_outlined,
  ];

  GameState() {
    _initializeGame();
  }

  void _initializeGame() {
    // Create pairs of cards with icons
    final List<IconData> selectedIcons = _icons.take(8).toList();
    final List<CardModel> newCards = [];

    for (int i = 0; i < selectedIcons.length; i++) {
      // Add two cards with the same icon (a pair)
      newCards.add(CardModel(id: i * 2, icon: selectedIcons[i]));
      newCards.add(CardModel(id: i * 2 + 1, icon: selectedIcons[i]));
    }

    // Shuffle cards
    newCards.shuffle();

    cards = newCards;
    notifyListeners();
  }

  void startGame() {
    if (gameStarted) return;

    gameStarted = true;
    gameWon = false;
    score = 0;
    moves = 0;
    duration = Duration.zero;

    // Start timer
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration = Duration(seconds: duration.inSeconds + 1);
      notifyListeners();
    });

    notifyListeners();
  }

  void flipCard(int index) {
    if (!canFlip || cards[index].isFlipped || cards[index].isMatched) {
      return;
    }

    if (gameStarted == false) {
      startGame();
    }

    cards[index] = cards[index].copyWith(isFlipped: true);

    if (firstCardIndex == null) {
      firstCardIndex = index;
    } else if (secondCardIndex == null) {
      secondCardIndex = index;
      moves++;
      _checkMatch();
    }

    notifyListeners();
  }

  void _checkMatch() {
    if (firstCardIndex == null || secondCardIndex == null) return;

    final firstCard = cards[firstCardIndex!];
    final secondCard = cards[secondCardIndex!];

    if (firstCard.icon == secondCard.icon) {
      // Match found!
      cards[firstCardIndex!] = cards[firstCardIndex!].copyWith(isMatched: true);
      cards[secondCardIndex!] = cards[secondCardIndex!].copyWith(
        isMatched: true,
      );
      score += 10;
      _resetSelection();

      // Check if game is won
      if (_isGameComplete()) {
        _endGame();
      }
    } else {
      // No match, flip back
      canFlip = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        cards[firstCardIndex!] = cards[firstCardIndex!].copyWith(
          isFlipped: false,
        );
        cards[secondCardIndex!] = cards[secondCardIndex!].copyWith(
          isFlipped: false,
        );
        _resetSelection();
        canFlip = true;
        notifyListeners();
      });
    }
  }

  void _resetSelection() {
    firstCardIndex = null;
    secondCardIndex = null;
  }

  bool _isGameComplete() {
    return cards.every((card) => card.isMatched);
  }

  void _endGame() {
    timer?.cancel();
    gameWon = true;
    notifyListeners();
  }

  void resetGame() {
    timer?.cancel();
    _resetSelection();
    canFlip = true;
    gameStarted = false;
    gameWon = false;
    _initializeGame();
  }

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
