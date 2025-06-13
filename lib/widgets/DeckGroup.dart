import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart';

class DeckGroup extends StatefulWidget {
  final String name;
  final String tipo;
  final int cartas;
  final List<String> cardIds; // IDs de las 3 cartas a mostrar

  const DeckGroup({
    super.key,
    required this.name,
    required this.tipo,
    required this.cartas,
    required this.cardIds,
  });

  @override
  State<DeckGroup> createState() => _DeckGroupState();
}

class _DeckGroupState extends State<DeckGroup> {
  final Pokeapi _pokeapi = Pokeapi();
  List<String> imagenesCartas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final List<String> urls = [];
    for (final id in widget.cardIds) {
      final card = await _pokeapi.api.getCard(id);
      urls.add(card.images?.large ?? '');
    }
    setState(() {
      imagenesCartas = urls;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () {
        // Tu lógica de navegación aquí
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: _loading
              ? const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: List.generate(3, (index) {
                          final int displayIndex = 3 - 1 - index;
                          final double rotation =
                              (displayIndex * -3.5) * (pi / 180);
                          final double leftOffset = displayIndex * 15.0;
                          final double topOffset = displayIndex * 5.0;
                          return Transform.translate(
                            offset: Offset(leftOffset, topOffset),
                            child: Transform.rotate(
                              angle: rotation,
                              child: Image.network(
                                imagenesCartas[displayIndex],
                                fit: BoxFit.scaleDown,
                                height: mediaQuery.size.height * 0.15,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.image_not_supported),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(widget.name,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(widget.tipo,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                            Text('${widget.cartas} cartas',
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
