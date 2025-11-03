import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameCompleteDialog extends StatelessWidget {
  final GameState gameState;

  const GameCompleteDialog({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.purple.shade400, Colors.blue.shade600],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 64, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You completed the game!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withAlpha((0.9 * 255).round()),
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow(Icons.timer, 'Time', gameState.formattedDuration),
            const SizedBox(height: 12),
            _buildStatRow(Icons.touch_app, 'Moves', gameState.moves.toString()),
            const SizedBox(height: 12),
            _buildStatRow(Icons.star, 'Score', gameState.score.toString()),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                gameState.resetGame();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple.shade700,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text(
                'Play Again',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.2 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withAlpha((0.8 * 255).round()),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
