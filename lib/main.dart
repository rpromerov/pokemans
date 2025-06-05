import 'dart:math';

                    import 'package:flutter/material.dart';
import 'package:pokemans/screens/LibraryScreen.dart';
import 'package:pokemans/widgets/AppScaffold.dart';

                    import 'screens/ProfileScreen.dart';

                    void main() {
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
                          home: const MyHomePage(title: 'PikaDecks'),
                          routes: {
                            ProfileScreen.routeName: (context) => const ProfileScreen(),
                            MyHomePage.routeName: (context) => const MyHomePage(title: 'PikaDecks'),
                            Libraryscreen.routeName: (context) =>  Libraryscreen(),

                          },
                        );
                      }
                    }

                    class MyHomePage extends StatefulWidget {
                      const MyHomePage({super.key, required this.title});
                      static const routeName = '/home';
                      final String title;

                      @override
                      State<MyHomePage> createState() => _MyHomePageState();
                    }

                    class _MyHomePageState extends State<MyHomePage> {
                      int _counter = 0;
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
                      void _incrementCounter() {
                        setState(() {
                          _counter++;
                        });
                      }

                      @override
                      Widget build(BuildContext context) {
                        void _navigate(String route) {
                          Navigator.pop(context); // Cierra el Drawer
                          Navigator.pushNamed(context, route);
                        }
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
                                  onTap: (){
                                    setState(() {
                                      currentGreeting = greetings[Random().nextInt(greetings.length)];
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