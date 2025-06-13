import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokemans/screens/deck_detail.dart';

class DeckGroup extends StatelessWidget {
  final String name;
  final String tipo;
  final int cartas;
  final List<String> imagenesCartas;
  const DeckGroup({
    super.key,
    this.name = "Mi mazo 1",
    required this.tipo,
    required this.cartas,
    required this.imagenesCartas,
  });
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeckDetail(
              name: name,
              tipo: tipo,
              pokemon: 31, // ✅ Este es el nombre correcto del parámetro
              entrenador: 15,
              energia: 14,
              debilidades: ['Fuego', 'Agua'],
              tipos: {
                'Agua': 40,
                'Psíquico': 30,
                'Planta': 30,
              }, // 👈 Asegúrate de pasar un Map<String, double>
              imagenesCartas: [
                'media/carta.png',
                'media/carta.png',
                'media/carta.png',
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: List.generate(3, (index) {
                    // Calculamos el desplazamiento y la rotación para cada carta
                    // La carta de más atrás (index 0) tendrá el mayor desplazamiento y rotación.
                    final int displayIndex = 3 - 1 - index;

                    final double rotation = (displayIndex * -3.5) *
                        (pi / 180); // Convertimos grados a radianes
                    final double leftOffset = displayIndex * 15.0;
                    final double topOffset = displayIndex * 5.0;

                    // Usamos Transform para aplicar los efectos
                    return Transform.translate(
                      offset: Offset(leftOffset, topOffset),
                      child: Transform.rotate(
                        angle: rotation,
                        child: Image.network(
                          imagenesCartas[displayIndex],
                          fit: BoxFit.scaleDown,
                          height: mediaQuery.size.height * 0.15,
                        ),
                      ),
                    );
                  }),
                ),
                // Expanded(
                //   flex: 1,
                //   child: Image.asset(
                //     'media/cardstack.png',
                //     cacheWidth: 300,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(tipo,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                      Text('$cartas cartas',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
