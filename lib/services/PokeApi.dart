// 1f36f025-0f6b-464a-aa21-405a567ac9f0

import 'package:pokemon_tcg/pokemon_tcg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Pokeapi {
  final api = PokemonTcgApi(apiKey: '1f36f025-0f6b-464a-aa21-405a567ac9f0');
  final db = FirebaseFirestore.instance;
  final usuario = FirebaseAuth.instance.currentUser;

  Pokeapi();

  void crearBiblioteca() {
    if (usuario == null) return;

    db.collection(usuario!.uid).doc('Biblioteca').set({
      'cartas': [],
      'fecha modificacion': FieldValue.serverTimestamp(),
      'cantidad cartas': 0
    });
  }

  void crearPerfil() {
    if (usuario == null) return;

    db.collection(usuario!.uid).doc("Perfil").set(
        {'cartas favoritas': [], 'cartas totales': 0, 'sets diferentes': 0});
  }

  void crearMazo(mazo, String nombre) {
    if (usuario == null) return;

    db.collection(usuario!.uid).doc("Mazos").set({
      'nombre': {
        'cartas': [],
        'debilidades': '',
        'cartas pokemon': 0,
        'cartas entrenador': 0,
        'cartas energia': 0
      },
    });
  }

  Future<List<PokemonCard>> getBiblioteca() async {
    final List<PokemonCard> pokemonCardList = [];
    final response = await db.collection(usuario!.uid).doc("Biblioteca").get();
    final cartasBiblioteca = response['cartas'];
    for (final cardId in cartasBiblioteca) {
      var carta = await api.getCard(cardId);
      pokemonCardList.add(carta);
    }
    return pokemonCardList;
  }
}
