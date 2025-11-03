import 'package:flutter/material.dart';

class CardModel {
  final int id;
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  CardModel({
    required this.id,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });

  CardModel copyWith({
    int? id,
    IconData? icon,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return CardModel(
      id: id ?? this.id,
      icon: icon ?? this.icon,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
