// 1f36f025-0f6b-464a-aa21-405a567ac9f0

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_tcg/pokemon_tcg.dart';

class Pokeapi {
  final api = PokemonTcgApi(apiKey: dotenv.env['POKEMON_TCG_API_KEY'] ?? '');
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

  void crearMazo(List<PokemonCard> cartas, String nombre) {
    if (usuario == null) return;

    db.collection(usuario!.uid).doc("Mazos").set({
      nombre: cartas.map((carta) => carta.id).toList(),
    });
  }

  Future<Map<String, List<PokemonCard>>> getMazos() async {
    if (usuario == null) return {};

    final response = await db.collection(usuario!.uid).doc("Mazos").get();
    if (!response.exists) return {};

    final mapa = <String, List<PokemonCard>>{};
    final cartasMazo = response.data();
    for (final entry in cartasMazo!.keys) {
      final nombreMazo = entry;
      final cartas = cartasMazo[entry] as List<dynamic>;
      for (final cardId in cartas) {
        var carta = await api.getCard(cardId);
        mapa.update(carta.name, (value) => [...value, carta],
            ifAbsent: () => [carta]);
      }
    }
    return mapa;
  }

  Future<List<PokemonCard>> buscarCartasPorNombre(String nombre) async {
    final url = Uri.https(
      'api.pokemontcg.io',
      '/v2/cards',
      {'q': 'name:$nombre', 'pageSize': '10'},
    );
    final response = await http.get(
      url,
      headers: {'X-Api-Key': dotenv.env['POKEMON_TCG_API_KEY'] ?? ''},
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

  Future<List<String>> getFavoritas() async {
    if (usuario == null) return [];
    final perfil = await db.collection(usuario!.uid).doc('Perfil').get();
    return List<String>.from(perfil['cartas favoritas'] ?? []);
  }

  Future<void> toggleFavorita(String cardId, List<String> favoritas) async {
    if (usuario == null) return;
    final doc = db.collection(usuario!.uid).doc('Perfil');
    final perfilSnapshot = await doc.get();
    var containsKey =
        perfilSnapshot.data()?.containsKey('cartas favoritas') ?? false;
    if (!containsKey) {
      await doc.set({'cartas favoritas': []}, SetOptions(merge: true));
    }
    final esFavorita = favoritas.contains(cardId);
    await doc.update({
      'cartas favoritas': esFavorita
          ? FieldValue.arrayRemove([cardId])
          : FieldValue.arrayUnion([cardId])
    });
  }

  // En lib/services/PokeApi.dart
  Future<List<Map<String, dynamic>>> getMazos() async {
    if (usuario == null) return [];
    final doc = await db.collection(usuario!.uid).doc("Mazos").get();
    if (!doc.exists) return [];
    final data = doc.data();
    if (data == null) return [];
    return [data];
  }

  Future<void> addCardToLibrary(String cardId) async {
    if (usuario == null) return;
    await db.collection(usuario!.uid).doc("Biblioteca").update({
      'cartas': FieldValue.arrayUnion([cardId]),
      'fecha modificacion': FieldValue.serverTimestamp(),
    });
  }
}
