import 'package:flutter/material.dart';
import 'package:pokemans/widgets/DeckGroup.dart';

class ProfileScreen extends StatelessWidget {
static const routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'media/profile.png',
                    fit: BoxFit.contain, // O BoxFit.cover según lo que prefieras
                    width: double.infinity,
                    height: 120, // Puedes ajustar la altura si lo deseas
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Usuario 1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Cartas totales: 99',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sets diferentes: 3',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                  
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mis cartas favoritas',
                    style: Theme.of(context).textTheme.titleMedium),
                Row(
                  children: List.generate(
                    4,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.asset(
                          'media/carta.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

          Text("Mis mazos",style: Theme.of(context).textTheme.titleMedium,),
          Expanded(
              child: SingleChildScrollView(

                child: Column(
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: double.infinity,
                      child: DeckGroup(
                        name: 'Mazo ${index + 1}',
                        tipo: 'Tipo ${index + 1}',
                        cartas: (index + 1) * 10,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}