# Firebase Configuration Guide

This guide will help you set up Firebase for the Memory Card Flip Game multiplayer features.

## Prerequisites

1. A Firebase account (sign up at [firebase.google.com](https://firebase.google.com))
2. Node.js installed (for Firebase CLI)
3. Flutter SDK installed

## Step 1: Install FlutterFire CLI

Open your terminal and run:

```bash
dart pub global activate flutterfire_cli
```

If you get a PATH error, add Flutter's bin directory to your PATH:
- macOS/Linux: `export PATH="$PATH":"$HOME/.pub-cache/bin"`
- Windows: Add `%APPDATA%\Pub\Cache\bin` to your PATH

## Step 2: Configure Firebase

1. **Create a Firebase Project** (if you don't have one):
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Add project"
   - Enter a project name (e.g., "memory-card-game")
   - Follow the setup wizard

2. **Run FlutterFire Configuration**:
   ```bash
   cd /Users/airm1/Development/projects/memory_card_flip_game
   flutterfire configure
   ```

3. **Select your Firebase project** from the list

4. **Select platforms** you want to configure:
   - ✅ Android
   - ✅ iOS (if developing for iOS)
   - ✅ Web (if developing for web)

This will:
- Generate `lib/firebase_options.dart` with your Firebase configuration
- Download `google-services.json` for Android to `android/app/`
- Download `GoogleService-Info.plist` for iOS to `ios/Runner/`
- Configure web Firebase options

## Step 3: Update Code Files

After running `flutterfire configure`, the following files will be updated automatically, but you may need to:

1. **Update `lib/main.dart`**:
   - Uncomment the import: `import 'firebase_options.dart';`
   - Uncomment the initialization line: `await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);`
   - Remove the old `await Firebase.initializeApp();` line

2. **Update `android/settings.gradle.kts`**:
   - Uncomment: `id("com.google.gms.google-services") version "4.4.2" apply false`

3. **Update `android/app/build.gradle.kts`**:
   - Uncomment: `id("com.google.gms.google-services")`

## Step 4: Enable Firestore Database

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Click "Firestore Database" in the left menu
4. Click "Create database"
5. Choose **Start in test mode** (for development)
6. Select a location for your database (choose closest to your users)

## Step 5: (Optional) Set Up Security Rules

For production, update Firestore security rules. In Firebase Console → Firestore Database → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /rooms/{roomId} {
      // Allow read/write for all authenticated users
      // For development, you can use:
      allow read, write: if true;
      
      // For production with authentication:
      // allow read, write: if request.auth != null;
    }
  }
}
```

## Step 6: Verify Setup

1. Run `flutter pub get`
2. Try building the app:
   ```bash
   flutter run
   ```
3. Test multiplayer features:
   - Create a room
   - Join a room
   - Check Firebase Console → Firestore to see if rooms are being created

## Troubleshooting

### Error: "Unable to establish connection on channel"
- Make sure you've run `flutterfire configure`
- Check that `google-services.json` exists in `android/app/`
- Verify `firebase_options.dart` exists in `lib/`
- Try `flutter clean` and rebuild

### Error: "FirebaseApp not initialized"
- Make sure `firebase_options.dart` is imported
- Verify `DefaultFirebaseOptions.currentPlatform` is used in initialization
- Check that all uncommented lines in `main.dart` are correct

### Android Build Errors
- Ensure Google Services plugin is added in `settings.gradle.kts` and `app/build.gradle.kts`
- Run `flutter clean` and rebuild
- Check that `google-services.json` is in the correct location

### iOS Build Errors
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Run `pod install` in the `ios/` directory
- Open `ios/Runner.xcworkspace` (not `.xcodeproj`) in Xcode

## Testing

After setup, you can test:
1. Single player mode (should work without Firebase)
2. Multiplayer mode (requires Firebase)
   - Create a room
   - Join with a room code
   - Play a game

## Next Steps

- Set up Firebase Authentication if you want user accounts
- Configure Firestore indexes if you plan to query rooms
- Set up production security rules before releasing

## Need Help?

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire CLI Documentation](https://firebase.flutter.dev/docs/cli/)

