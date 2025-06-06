import 'package:flutter/material.dart';
import 'package:pokemans/screens/deck_detail.dart';
class DeckGroup extends StatelessWidget {
  final String name;
  final String tipo;
  final int cartas;
  const DeckGroup({super.key
  ,this.name = "Mi mazo 1", required this.tipo, required this.cartas,});
@override
 Widget build(BuildContext context) {
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
            Expanded(
              flex: 1,
              child: Image.asset(
                'media/cardstack.png',
                cacheWidth: 300, 
                fit: BoxFit.contain,

              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(tipo, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  Text('$cartas cartas', style: const TextStyle(fontSize: 16, color: Colors.grey)),
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
