import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pokemans/screens/Auth_gate.dart';
import 'package:pokemans/screens/CreatorScreen.dart';
import 'package:pokemans/screens/DecksScreen.dart';
import 'package:pokemans/screens/HomePage.dart';
import 'package:pokemans/screens/LibraryScreen.dart';
import 'package:pokemans/screens/LoginScreen.dart';

import 'firebase_options.dart';
import 'screens/ProfileScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PikaDecks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      routes: {
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        MyHomePage.routeName: (context) => const MyHomePage(title: 'PikaDecks'),
        Libraryscreen.routeName: (context) => Libraryscreen(),
        DecksScreen.routeName: (context) => const DecksScreen(),
        CreatorScreen.routeName: (context) => const CreatorScreen(),
        Loginscreen.routeName: (context) => const Loginscreen(),
      },
    );
  }
}
