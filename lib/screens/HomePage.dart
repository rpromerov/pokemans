import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokemans/widgets/AppScaffold.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  static const routeName = '/home';
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<String> greetings = [
    "¡Bienvenido, entrenador Pokémon!",
    "¡Atrápalos a todos!",
    "¡Que tu aventura sea legendaria!",
    "¡Listo para una batalla Pokémon!",
    "¡Que la suerte de Pikachu te acompañe!",
    "¡Hora de lanzar tu Pokébola!",
    "¡Entrena fuerte y evoluciona!",
    "¡Que tus capturas sean épicas!",
    "¡Explora y descubre nuevos Pokémon!",
    "¡Hazte con todos, maestro Pokémon!",
    "¡Que el poder de Charizard te inspire!",
    "¡Sigue el camino hacia la Liga Pokémon!",
    "¡Que tu equipo siempre esté listo para luchar!",
    "¡Descubre el mundo Pokémon sin límites!",
    "¡Que la amistad con tus Pokémon crezca cada día!",
    "¡Recuerda usar desodorante en el torneo!"
  ];

  String get greeting => greetings[Random().nextInt(greetings.length)];
  String currentGreeting = greetings[Random().nextInt(greetings.length)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        content: Text("¡Haz tap en Pikachu!"),
        duration: Duration(seconds: 3),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "PikaDecks",
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Image.asset(
                'media/pikachu.png',
                width: MediaQuery.of(context).size.width / 3,
                fit: BoxFit.contain,
              ),
              onTap: () {
                setState(() {
                  currentGreeting =
                      greetings[Random().nextInt(greetings.length)];
                });
              },
            ),
            Text(
              greetings[Random().nextInt(greetings.length)],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
