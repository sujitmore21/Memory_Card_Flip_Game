import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_state.dart';
import '../widgets/memory_card.dart';
import '../widgets/game_complete_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    // Show game completion dialog when game is won
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gameState = context.read<GameState>();
      gameState.addListener(_gameStateListener);
    });
  }

  void _gameStateListener() {
    final gameState = context.read<GameState>();
    if (gameState.gameWon && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => GameCompleteDialog(gameState: gameState),
      );
    }
  }

  @override
  void dispose() {
    context.read<GameState>().removeListener(_gameStateListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(child: _buildGameGrid(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatCard(
                    context,
                    Icons.timer_outlined,
                    'Time',
                    gameState.formattedDuration,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    context,
                    Icons.star_outline,
                    'Score',
                    gameState.score.toString(),
                    Colors.amber,
                  ),
                  _buildStatCard(
                    context,
                    Icons.touch_app_outlined,
                    'Moves',
                    gameState.moves.toString(),
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: gameState.resetGame,
                icon: const Icon(Icons.refresh),
                label: const Text('New Game'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withAlpha((0.2 * 255).round()),
              blurRadius: 4,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    return Consumer<GameState>(
      builder: (context, gameState, child) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
            ),
            itemCount: gameState.cards.length,
            itemBuilder: (context, index) {
              return MemoryCard(
                card: gameState.cards[index],
                onTap: () => gameState.flipCard(index),
              );
            },
          ),
        );
      },
    );
  }
}
