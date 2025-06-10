// lib/app_scaffold.dart
import 'package:flutter/material.dart';
import 'package:pokemans/main.dart';
import 'package:pokemans/screens/CreatorScreen.dart';
import 'package:pokemans/screens/LoginScreen.dart';

import '../screens/DecksScreen.dart';
import '../screens/LibraryScreen.dart';
import '../screens/ProfileScreen.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const AppScaffold({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
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
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pushNamed(context, MyHomePage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pushNamed(context, ProfileScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.library_books),
              title: const Text('Biblioteca'),
              onTap: () {
                Navigator.pushNamed(context, Libraryscreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_customize),
              title: const Text('Mis mazos'),
              onTap: () {
                Navigator.pushNamed(context, DecksScreen.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Creador'),
              onTap: () {
                Navigator.pushNamed(context, CreatorScreen.routeName);
              },
            ),
            // temp
            ListTile(
              leading: const Icon(Icons.create),
              title: const Text('Login'),
              onTap: () {
                Navigator.pushNamed(context, Loginscreen.routeName);
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
