import 'dart:math';

                    import 'package:flutter/material.dart';

                    import 'ProfileScreen.dart';

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
                          },
                        );
                      }
                    }

                    class MyHomePage extends StatefulWidget {
                      const MyHomePage({super.key, required this.title});
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
                        return Scaffold(
                          appBar: AppBar(
                            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                            title: Text(widget.title),
                          ),
                          drawer: Drawer(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                const DrawerHeader(
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                  ),
                                  child: Text(
                                    'Opciones',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: const Icon(Icons.person),
                                  title: const Text('Perfil'),
                                  onTap: () {
                                    Navigator.pushNamed(context, ProfileScreen.routeName);
                                  },
                                ),
                                const ListTile(
                                  leading: Icon(Icons.library_books),
                                  title: Text('Biblioteca'),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.dashboard_customize),
                                  title: Text('Mis mazos'),
                                ),
                                const ListTile(
                                  leading: Icon(Icons.create),
                                  title: Text('Creador'),
                                ),
                              ],
                            ),
                          ),
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'media/pikachu.png',
                                  width: MediaQuery.of(context).size.width / 3,
                                  fit: BoxFit.contain,
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