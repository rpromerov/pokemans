import 'package:flutter/material.dart';

class DeckGroup extends StatelessWidget {
  final String name;
  final String tipo;
  final int cartas;
  const DeckGroup({super.key
  ,this.name = "Mi mazo 1", required this.tipo, required this.cartas,});

 Widget build(BuildContext context) {
                    return Padding(
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
                    );
                  }
}
