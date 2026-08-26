import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TopList',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Dark mode theme
        brightness: Brightness.dark,
        useMaterial3: true,
        
        // Color scheme - dark with red/orange accent
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFff5722), // Red-orange
          secondary: const Color(0xFFff9100), // Orange
          tertiary: const Color(0xFFffc107), // Yellow
          background: const Color(0xFF121212), // Dark background
          surface: const Color(0xFF1E1E1E), // Slightly lighter dark
          error: const Color(0xFFcf6679),
        ),
        
        // Scaffold background
        scaffoldBackgroundColor: const Color(0xFF121212),
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Text theme
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFFe0e0e0),
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: Color(0xFFb0b0b0),
            fontSize: 14,
          ),
        ),
        
        // Card theme
        cardTheme: CardThemeData(
          color: const Color(0xFF1E1E1E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        
        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFff5722),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}
