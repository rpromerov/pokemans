import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemans/screens/HomePage.dart';
import 'package:pokemans/screens/LoginScreen.dart';
import 'package:pokemans/services/PokeApi.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // Usar FutureBuilder para esperar el resultado de tieneBiblioteca
          return FutureBuilder<bool>(
            future: Pokeapi().tieneBiblioteca(),
            builder: (context, bibliotecaSnapshot) {
              if (bibliotecaSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!bibliotecaSnapshot.hasData || !bibliotecaSnapshot.data!) {
                // Si no tiene biblioteca, la creamos
                Pokeapi().crearBiblioteca();
              }
              return const MyHomePage(
                title: 'PikaDecks',
              );
            },
          );
        } else {
          return const Loginscreen();
        }
      },
    );
  }
}
