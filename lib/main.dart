import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/game_state.dart';
import 'screens/splash_screen.dart';
import 'screens/mode_selection_screen.dart';
// Uncomment after running flutterfire configure:
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // After running flutterfire configure, uncomment the line below:
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // For now, using default initialization:
    await Firebase.initializeApp();
  } catch (e) {
    // Firebase initialization failed - app can still run in single player mode
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MaterialApp(
        title: 'Memory Game 2.0',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.purple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: {'/mode-selection': (context) => const ModeSelectionScreen()},
      ),
    );
  }
}
