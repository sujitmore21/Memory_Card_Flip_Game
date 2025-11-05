import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'game_state.dart';
import 'card_model.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class MultiplayerGameState extends GameState {
  FirebaseFirestore? _firestore;
  String? roomId;
  String? playerId;
  String playerName = 'Player';
  List<String> players = [];
  String? currentTurnPlayerId;
  StreamSubscription<DocumentSnapshot>? _roomSubscription;
  bool isHost = false;

  FirebaseFirestore get firestore {
    try {
      _firestore ??= FirebaseFirestore.instance;
      return _firestore!;
    } catch (e) {
      throw Exception(
        'Firebase is not initialized. Please configure Firebase to use multiplayer features.',
      );
    }
  }

  MultiplayerGameState() {
    // Lazy initialization - don't call SharedPreferences in constructor
  }

  Future<void> _initializePlayerId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      playerId = prefs.getString('player_id');
      playerName = prefs.getString('player_name') ?? 'Player';

      if (playerId == null) {
        playerId = _generatePlayerId();
        await prefs.setString('player_id', playerId!);
      }
    } catch (e) {
      // If SharedPreferences fails, generate a temporary player ID
      // This can happen if platform channels aren't ready yet
      if (playerId == null) {
        playerId = _generatePlayerId();
      }
    }
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  Future<String> createRoom(String playerName) async {
    // Ensure playerId is initialized
    if (playerId == null) {
      await _initializePlayerId();
    }

    this.playerName = playerName;
    this.isHost = true;

    // Try to save player name, but don't fail if it doesn't work
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('player_name', playerName);
    } catch (e) {
      // Ignore errors when saving player name
    }

    // Generate room ID
    roomId = _generateRoomId();

    // Initialize game
    initializeGame();

    // Create room in Firestore
    await firestore.collection('rooms').doc(roomId).set({
      'createdAt': FieldValue.serverTimestamp(),
      'hostId': playerId,
      'players': [
        {'id': playerId, 'name': playerName, 'score': 0, 'isReady': false},
      ],
      'gameState': {
        'cards': _cardsToJson(cards),
        'firstCardIndex': null,
        'secondCardIndex': null,
        'canFlip': true,
        'gameStarted': false,
        'gameWon': false,
        'currentTurnPlayerId': playerId,
      },
      'status': 'waiting', // waiting, playing, finished
    });

    players = [playerId!];
    currentTurnPlayerId = playerId;
    _listenToRoom();
    notifyListeners();

    return roomId!;
  }

  Future<bool> joinRoom(String roomCode, String playerName) async {
    // Ensure playerId is initialized
    if (playerId == null) {
      await _initializePlayerId();
    }

    this.playerName = playerName;
    this.isHost = false;

    // Try to save player name, but don't fail if it doesn't work
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('player_name', playerName);
    } catch (e) {
      // Ignore errors when saving player name
    }

    roomId = roomCode;

    try {
      final roomDoc = await firestore.collection('rooms').doc(roomId).get();

      if (!roomDoc.exists) {
        return false;
      }

      final roomData = roomDoc.data()!;
      if (roomData['status'] != 'waiting') {
        return false;
      }

      // Add player to room
      await firestore.collection('rooms').doc(roomId).update({
        'players': FieldValue.arrayUnion([
          {'id': playerId, 'name': playerName, 'score': 0, 'isReady': false},
        ]),
      });

      _listenToRoom();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void _listenToRoom() {
    if (roomId == null) return;

    _roomSubscription?.cancel();
    _roomSubscription = firestore
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .listen((snapshot) {
          if (!snapshot.exists) return;

          final data = snapshot.data()!;
          final gameStateData = data['gameState'] as Map<String, dynamic>?;
          final roomPlayers = (data['players'] as List<dynamic>?) ?? [];

          // Update players list
          players = roomPlayers.map((p) => p['id'] as String).toList();

          // Update game state from Firestore
          if (gameStateData != null) {
            cards = _cardsFromJson(gameStateData['cards'] as List<dynamic>);
            firstCardIndex = gameStateData['firstCardIndex'] as int?;
            secondCardIndex = gameStateData['secondCardIndex'] as int?;
            canFlip = gameStateData['canFlip'] as bool? ?? true;
            gameStarted = gameStateData['gameStarted'] as bool? ?? false;
            gameWon = gameStateData['gameWon'] as bool? ?? false;
            currentTurnPlayerId =
                gameStateData['currentTurnPlayerId'] as String?;

            // Update player scores
            final myPlayerData = roomPlayers.firstWhere(
              (p) => p['id'] == playerId,
              orElse: () => null,
            );
            if (myPlayerData != null) {
              score = myPlayerData['score'] as int? ?? 0;
            }
          }

          notifyListeners();
        });
  }

  @override
  void flipCard(int index) {
    if (!canFlip || cards[index].isFlipped || cards[index].isMatched) {
      return;
    }

    // Check if it's this player's turn
    if (currentTurnPlayerId != playerId) {
      return;
    }

    if (gameStarted == false) {
      startGame();
    }

    // Vibrate on card flip
    Vibration.hasVibrator().then((hasVibrator) {
      if (hasVibrator) {
        Vibration.vibrate(duration: 50);
      }
    });

    cards[index] = cards[index].copyWith(isFlipped: true);

    int? newFirstIndex = firstCardIndex;
    int? newSecondIndex = secondCardIndex;
    int newMoves = moves;

    if (firstCardIndex == null) {
      newFirstIndex = index;
    } else if (secondCardIndex == null) {
      newSecondIndex = index;
      newMoves = moves + 1;
    }

    // Update local state
    firstCardIndex = newFirstIndex;
    secondCardIndex = newSecondIndex;
    moves = newMoves;

    // Sync to Firestore
    _syncGameStateToFirestore();

    if (newSecondIndex != null) {
      Future.delayed(const Duration(milliseconds: 500), () {
        checkMatch();
      });
    }

    notifyListeners();
  }

  @override
  void checkMatch() {
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
      resetSelection();

      // Update score in Firestore
      _updatePlayerScore(score);

      // Check if game is won
      if (isGameComplete()) {
        endGame();
      } else {
        // Keep turn if match found
        _syncGameStateToFirestore();
      }
    } else {
      // No match, flip back and switch turn
      canFlip = false;
      Future.delayed(const Duration(milliseconds: 1000), () {
        cards[firstCardIndex!] = cards[firstCardIndex!].copyWith(
          isFlipped: false,
        );
        cards[secondCardIndex!] = cards[secondCardIndex!].copyWith(
          isFlipped: false,
        );
        resetSelection();

        // Switch to next player's turn
        _switchTurn();
        canFlip = true;
        _syncGameStateToFirestore();
        notifyListeners();
      });
    }
  }

  void _switchTurn() {
    if (players.isEmpty) return;

    final currentIndex = players.indexOf(currentTurnPlayerId ?? '');
    final nextIndex = (currentIndex + 1) % players.length;
    currentTurnPlayerId = players[nextIndex];
  }

  void _syncGameStateToFirestore() {
    if (roomId == null) return;

    firestore.collection('rooms').doc(roomId).update({
      'gameState': {
        'cards': _cardsToJson(cards),
        'firstCardIndex': firstCardIndex,
        'secondCardIndex': secondCardIndex,
        'canFlip': canFlip,
        'gameStarted': gameStarted,
        'gameWon': gameWon,
        'currentTurnPlayerId': currentTurnPlayerId,
        'moves': moves,
      },
    });
  }

  void _updatePlayerScore(int newScore) {
    if (roomId == null) return;

    firestore.collection('rooms').doc(roomId).get().then((snapshot) {
      if (!snapshot.exists) return;

      final players = (snapshot.data()!['players'] as List<dynamic>).map((p) {
        if (p['id'] == playerId) {
          return {...p as Map, 'score': newScore};
        }
        return p;
      }).toList();

      firestore.collection('rooms').doc(roomId).update({'players': players});
    });
  }

  Future<void> setReady(bool ready) async {
    if (roomId == null) return;

    await firestore.collection('rooms').doc(roomId).get().then((snapshot) {
      if (!snapshot.exists) return;

      final players = (snapshot.data()!['players'] as List<dynamic>).map((p) {
        if (p['id'] == playerId) {
          return {...p as Map, 'isReady': ready};
        }
        return p;
      }).toList();

      firestore.collection('rooms').doc(roomId).update({'players': players});
    });
  }

  Future<void> startMultiplayerGame() async {
    if (roomId == null || !isHost) return;

    await firestore.collection('rooms').doc(roomId).update({
      'status': 'playing',
      'gameState.gameStarted': true,
      'gameState.currentTurnPlayerId': players.isNotEmpty
          ? players[0]
          : playerId,
    });
  }

  String _generateRoomId() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(6, (_) => chars[random.nextInt(chars.length)]).join();
  }

  List<Map<String, dynamic>> _cardsToJson(List<CardModel> cards) {
    return cards
        .map(
          (card) => {
            'id': card.id,
            'iconCodePoint': card.icon.codePoint,
            'iconFontFamily': card.icon.fontFamily,
            'iconFontPackage': card.icon.fontPackage,
            'isFlipped': card.isFlipped,
            'isMatched': card.isMatched,
          },
        )
        .toList();
  }

  List<CardModel> _cardsFromJson(List<dynamic> json) {
    return json.map((item) {
      final icon = IconData(
        item['iconCodePoint'] as int,
        fontFamily: item['iconFontFamily'] as String?,
        fontPackage: item['iconFontPackage'] as String?,
      );
      return CardModel(
        id: item['id'] as int,
        icon: icon,
        isFlipped: item['isFlipped'] as bool? ?? false,
        isMatched: item['isMatched'] as bool? ?? false,
      );
    }).toList();
  }

  @override
  void resetGame() {
    if (roomId == null) {
      super.resetGame();
      return;
    }

    // Reset game in Firestore
    initializeGame();
    _syncGameStateToFirestore();
    if (isHost) {
      firestore.collection('rooms').doc(roomId).update({'status': 'waiting'});
    }
  }

  @override
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

    _syncGameStateToFirestore();
    notifyListeners();
  }

  @override
  void endGame() {
    timer?.cancel();
    gameWon = true;

    if (roomId != null) {
      firestore.collection('rooms').doc(roomId).update({
        'gameState.gameWon': true,
        'status': 'finished',
      });
    }

    notifyListeners();
  }

  Future<void> leaveRoom() async {
    _roomSubscription?.cancel();

    if (roomId != null && playerId != null) {
      try {
        final roomDoc = await firestore.collection('rooms').doc(roomId).get();
        if (roomDoc.exists) {
          final players = (roomDoc.data()!['players'] as List<dynamic>)
              .where((p) => p['id'] != playerId)
              .toList();

          if (players.isEmpty) {
            // Delete room if no players left
            await firestore.collection('rooms').doc(roomId).delete();
          } else {
            // Remove player from room
            await firestore.collection('rooms').doc(roomId).update({
              'players': players,
            });
          }
        }
      } catch (e) {
        // Ignore errors when leaving
      }
    }

    roomId = null;
    players.clear();
  }

  @override
  void dispose() {
    _roomSubscription?.cancel();
    leaveRoom();
    super.dispose();
  }

  bool get isMyTurn => currentTurnPlayerId == playerId;
  String get currentTurnPlayerName {
    if (currentTurnPlayerId == null) return '';
    // This would need to be looked up from room data
    return currentTurnPlayerId == playerId ? 'Your' : 'Opponent\'s';
  }
}
