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
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade300, width: 2),
            ),
            child: Icon(
              card.icon,
              size: cardSize * 0.5,
              color: Colors.green.shade700,
            ),
          )
          .animate()
          .fadeIn(duration: 200.ms)
          .scale(begin: const Offset(0.8, 0.8), duration: 200.ms);
    }

    if (card.isFlipped) {
      return Container(
        width: cardSize,
        height: cardSize,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.shade300, width: 2),
        ),
        child: Icon(
          card.icon,
          size: cardSize * 0.5,
          color: Colors.blue.shade700,
        ),
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
              colors: [Colors.purple.shade400, Colors.purple.shade600],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.shade700, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.shade200,
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Icon(
            Icons.question_mark,
            size: cardSize * 0.5,
            color: Colors.white,
          ),
        )
        .animate()
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withAlpha((0.3 * 255).round()),
        )
        .then()
        .shimmer(
          duration: 1500.ms,
          color: Colors.white.withAlpha((0.3 * 255).round()),
        );
  }
}
