# Memory Card Flip Game 🎮

A beautiful and modern memory matching game built with Flutter. Test your memory by flipping cards to find matching pairs!

## Features ✨

- **4x4 Grid Layout**: Randomly shuffled cards for endless variety
- **Smooth Animations**: Beautiful flip animations powered by `flutter_animate`
- **Timer**: Track how long it takes you to complete the game
- **Score Tracking**: Earn points for matching pairs
- **Move Counter**: See how many moves you made
- **Win Dialog**: Celebrate your victory with a completion dialog
- **Modern UI**: Beautiful gradient design with a purple theme

## Game Rules 📋

1. Click "New Game" to start
2. Click on cards to flip them and reveal icons
3. Try to match pairs of cards with the same icons
4. Matched cards stay revealed
5. The game ends when all pairs are found
6. Your score is based on successful matches!

## Technologies Used 🛠️

- **Flutter**: UI framework
- **flutter_animate**: Smooth animations
- **Provider**: State management
- **Material Design 3**: Modern UI components

## Project Structure 📁

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── card_model.dart       # Card data model
│   └── game_state.dart       # Game logic and state management
├── screens/
│   └── game_screen.dart      # Main game screen
└── widgets/
    ├── memory_card.dart      # Individual card widget
    └── game_complete_dialog.dart  # Win dialog

```

## Getting Started 🚀

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- IDE (VS Code, Android Studio, or Cursor)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd memory_card_flip_game
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Build

To build for web:
```bash
flutter build web
```

To build for Android:
```bash
flutter build apk
```

To build for iOS:
```bash
flutter build ios
```

## Learning Concepts 🎓

This project demonstrates:

- **Animation**: Using `flutter_animate` for smooth card flip and completion animations
- **State Management**: Managing game state with Provider
- **List Management**: Randomizing and managing card states
- **UI/UX Design**: Creating an engaging and modern interface
- **Game Logic**: Implementing matching logic and win conditions

## Screenshots 📸

The game features:
- Gradient purple and blue backgrounds
- Animated card flips with smooth transitions
- Real-time stats display (time, score, moves)
- Celebration dialog on completion

## Future Enhancements 🔮

Potential features to add:
- Different difficulty levels (3x4, 6x6 grids)
- Sound effects
- Best time/high score tracking
- Card themes (animals, flags, numbers)
- Multiplayer mode
- Card flip sound effects

## License 📄

This project is open source and available under the MIT License.

## Contributing 🤝

Contributions are welcome! Feel free to fork, modify, and submit pull requests.

## Acknowledgments 🙏

Built as a learning project to explore Flutter animations and game development concepts.
