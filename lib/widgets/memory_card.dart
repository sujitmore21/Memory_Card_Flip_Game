import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/card_model.dart';

class MemoryCard extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;
  final double cardSize;

  const MemoryCard({
    super.key,
    required this.card,
    required this.onTap,
    this.cardSize = 80.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    if (card.isMatched) {
      return Container(
            width: cardSize,
            height: cardSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.green.shade400, Colors.green.shade600],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.5),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(card.icon, size: cardSize * 0.55, color: Colors.white),
          )
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(
            begin: const Offset(0.8, 0.8),
            duration: 300.ms,
            curve: Curves.elasticOut,
          );
    }

    if (card.isFlipped) {
      return Container(
        width: cardSize,
        height: cardSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade300, Colors.blue.shade500],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(card.icon, size: cardSize * 0.55, color: Colors.white),
      ).animate().scale(
        begin: const Offset(0.0, 1.0),
        end: const Offset(1.0, 1.0),
        duration: 300.ms,
        curve: Curves.easeOut,
      );
    }

    return Container(
          width: cardSize,
          height: cardSize,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey.shade200],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: -2,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Icon(
            Icons.question_mark,
            size: cardSize * 0.45,
            color: Colors.grey.shade600,
          ),
        )
        .animate()
        .shimmer(
          duration: 2000.ms,
          color: Colors.white.withAlpha((0.4 * 255).round()),
          angle: -0.5,
        )
        .then()
        .shimmer(
          duration: 2000.ms,
          color: Colors.white.withAlpha((0.4 * 255).round()),
          angle: -0.5,
        );
  }
}
