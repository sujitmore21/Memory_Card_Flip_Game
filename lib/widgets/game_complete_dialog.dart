import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/game_state.dart';

class GameCompleteDialog extends StatelessWidget {
  final GameState gameState;

  const GameCompleteDialog({super.key, required this.gameState});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.transparent,
      child:
          Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.shade700,
                      Colors.purple.shade600,
                      Colors.indigo.shade700,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Celebration icon with enhanced animations
                    _buildCelebrationIcon(),
                    const SizedBox(height: 20),
                    // Congratulations text with shimmer effect
                    _buildCongratulationsText(),
                    const SizedBox(height: 8),
                    Text(
                      'You completed the game!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withAlpha((0.95 * 255).round()),
                        letterSpacing: 0.5,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                    const SizedBox(height: 32),
                    _buildStatRow(
                          Icons.timer_rounded,
                          'Time',
                          gameState.formattedDuration,
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 500.ms)
                        .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                        ),
                    const SizedBox(height: 14),
                    _buildStatRow(
                          Icons.touch_app_rounded,
                          'Moves',
                          gameState.moves.toString(),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 600.ms)
                        .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                        ),
                    const SizedBox(height: 14),
                    _buildStatRow(
                          Icons.star_rounded,
                          'Score',
                          gameState.score.toString(),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 700.ms)
                        .slideX(begin: -0.3, end: 0, curve: Curves.easeOutCubic)
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                        ),
                    const SizedBox(height: 32),
                    _buildPlayAgainButton(context),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.elasticOut,
              ),
    );
  }

  Widget _buildCelebrationIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glowing background effect
        Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.amber.withOpacity(0.3),
                    Colors.orange.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.3, 1.3),
              duration: 1500.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.3, 1.3),
              end: const Offset(1, 1),
              duration: 1500.ms,
              curve: Curves.easeInOut,
            ),
        // Main celebration icon
        Icon(Icons.celebration_rounded, size: 80, color: Colors.amber.shade300)
            .animate()
            .scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
            )
            .then()
            .shake(duration: 400.ms, hz: 4)
            .then()
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.1, 1.1),
              duration: 800.ms,
              curve: Curves.easeInOut,
            )
            .then()
            .scale(
              begin: const Offset(1.1, 1.1),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.easeInOut,
            ),
      ],
    );
  }

  Widget _buildCongratulationsText() {
    return Stack(
          children: [
            // Glow effect behind text
            Text(
                  'Congratulations!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 2
                      ..color = Colors.amber.withOpacity(0.5),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 1000.ms, begin: 0.3)
                .then()
                .fadeOut(duration: 1000.ms, begin: 0.7),
            // Main text
            Text(
              'Congratulations!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
                shadows: [
                  Shadow(
                    color: Colors.amber.withOpacity(0.8),
                    blurRadius: 12,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 300.ms)
        .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
        .then()
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          duration: 2000.ms,
          color: Colors.amber.withOpacity(0.5),
          angle: 0,
        );
  }

  Widget _buildPlayAgainButton(BuildContext context) {
    return ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            gameState.resetGame();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 8,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: const Text(
            'Play Again',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 500.ms, delay: 800.ms)
        .scale(
          begin: const Offset(0.7, 0.7),
          end: const Offset(1, 1),
          curve: Curves.elasticOut,
        )
        .then()
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.05, 1.05),
          end: const Offset(1, 1),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha((0.25 * 255).round()),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.2 * 255).round()),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white.withAlpha((0.9 * 255).round()),
              letterSpacing: 0.5,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
