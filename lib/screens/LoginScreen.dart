import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  static const routeName = '/login';

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final userCredential = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _registerWithEmail(String email, String password) async {
    // Aquí iría la lógica de registro con correo electrónico
    try {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Usuario registrado: ${user.user?.uid}");
    } catch (e) {
      print("Error al registrarse: $e");
    }
  }

  Future<void> _loginWithEmail(String email, String password) async {
    // Aquí iría la lógica de inicio de sesión con correo electrónico
    try {
      UserCredential user =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Usuario autenticado: ${user.user?.uid}");
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '¡Bienvenido a PikaDecks!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Flexible(
                child: Image.asset(
                  'media/pikachu.png',
                  width: MediaQuery.of(context).size.width / 3,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  signInWithGoogle().then((UserCredential user) {
                    print("Usuario autenticado con Google: ${user.user?.uid}");
                  }).catchError((e) {
                    print("Error al iniciar sesión con Google: $e");
                  });
                },
                child: const Text('Iniciar sesión con Google'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _loginWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('Iniciar Sesión'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _registerWithEmail(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('Registrarse'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
