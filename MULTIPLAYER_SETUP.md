# Multiplayer Feature Setup Guide

## Overview

The Memory Card Flip Game now supports real-time multiplayer gameplay where multiple players can play together on different devices using Firebase Firestore for synchronization.

## Features Added

1. **Mode Selection Screen**: Choose between Single Player and Multiplayer modes
2. **Room Creation**: Host can create a game room with a unique 6-character room code
3. **Room Joining**: Players can join using the room code
4. **Waiting Room**: Players wait in a lobby until the host starts the game
5. **Real-time Synchronization**: Game state is synced in real-time across all devices
6. **Turn-based Gameplay**: Players take turns flipping cards
7. **Score Tracking**: Individual player scores are tracked and displayed

## Firebase Setup Required

To use the multiplayer feature, you need to set up Firebase:

1. **Create a Firebase Project**:
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create a new project or use an existing one

2. **Add Flutter to Firebase**:
   - Install Firebase CLI: `npm install -g firebase-tools`
   - Install FlutterFire CLI: `dart pub global activate flutterfire_cli`
   - Run: `flutterfire configure` in your project directory
   - Select your Firebase project and platforms (Android, iOS, Web)

3. **Firestore Database**:
   - Enable Firestore Database in Firebase Console
   - Start in test mode (for development) or set up security rules
   - The app will automatically create a `rooms` collection

4. **Security Rules** (for production):
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /rooms/{roomId} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

## How to Use

### For Host (Creating Room):
1. Select "Multiplayer" from mode selection
2. Choose "Create Room"
3. Enter your name
4. Share the room code with friends
5. Wait for players to join
6. Click "Start Game" when ready

### For Players (Joining Room):
1. Select "Multiplayer" from mode selection
2. Choose "Join Room"
3. Enter the room code provided by the host
4. Enter your name
5. Wait in the waiting room
6. Game starts automatically when host clicks "Start Game"

## Gameplay Rules (Multiplayer)

- Players take turns flipping cards
- If you make a match, you keep your turn
- If you don't make a match, it's the next player's turn
- Each match is worth 10 points
- The player with the highest score wins when all cards are matched

## Technical Details

- **Real-time Sync**: Uses Firestore snapshots for real-time updates
- **Game State**: All card states, scores, and turn information are synchronized
- **Room Management**: Rooms are automatically cleaned up when all players leave
- **Offline Support**: Single player mode works without Firebase

## Note

If Firebase is not configured, the app will still work in single player mode. The multiplayer features require Firebase to be properly set up.
