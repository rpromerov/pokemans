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
      // 1. Escuchar el stream de cambios de estado de autenticación
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Muestra un indicador de carga mientras se verifica el estado
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Si el snapshot tiene datos, significa que el usuario ha iniciado sesión
        if (snapshot.hasData) {
          // Usuario está logeado, lo dirigimos a la pantalla principal
          Pokeapi().crearBiblioteca();
          return const MyHomePage(
            title: 'PikaDecks',
          );
        } else {
          // 3. Si no hay datos, el usuario no ha iniciado sesión
          // Lo dirigimos a la pantalla de login
          return const Loginscreen();
        }
      },
    );
  }
}
