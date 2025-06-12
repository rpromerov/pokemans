// 1f36f025-0f6b-464a-aa21-405a567ac9f0

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_tcg/pokemon_tcg.dart';

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

  Future<List<PokemonCard>> buscarCartasPorNombre(String nombre) async {
    final url = Uri.https(
      'api.pokemontcg.io',
      '/v2/cards',
      {'q': 'name:$nombre', 'pageSize': '10'},
    );
    final response = await http.get(
      url,
      headers: {'X-Api-Key': '1f36f025-0f6b-464a-aa21-405a567ac9f0'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cardsJson = data['data'];
      return cardsJson.map((json) => PokemonCard.fromJson(json)).toList();
    } else {
      throw Exception('Error al buscar cartas');
    }
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

  Future<bool> tieneBiblioteca() async {
    if (usuario == null) return false;

    final doc = db.collection(usuario!.uid).doc("Biblioteca");
    try {
      final snapshot = await doc.get();
      return snapshot.exists;
    } catch (_) {
      return false;
    }
  }
}
