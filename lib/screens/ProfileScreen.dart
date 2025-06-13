import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart';
import 'package:pokemans/widgets/AppScaffold.dart';
import 'package:pokemans/widgets/DeckGroup.dart';
import 'package:pokemon_tcg/pokemon_tcg.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Pokeapi _pokeapi = Pokeapi();
  List<PokemonCard> _favoritas = [];
  bool _loading = true;
  int _cartasTotales = 0;
  int _setsDiferentes = 0;
  List<Map<String, dynamic>> _mazos = [];

  @override
  void initState() {
    super.initState();
    _loadFavoritas();
    _loadCartasTotales();
    _loadMazos();
  }

  Future<void> _loadFavoritas() async {
    final favoritasIds = await _pokeapi.getFavoritas();
    final favoritas = <PokemonCard>[];
    for (final id in favoritasIds) {
      try {
        final card = await _pokeapi.api.getCard(id);
        favoritas.add(card);
      } catch (_) {}
    }
    setState(() {
      _favoritas = favoritas;
      _loading = false;
    });
  }

  Future<void> _loadCartasTotales() async {
    final cards = await _pokeapi.getBiblioteca();
    final uniqueSets = <String>{};
    for (final card in cards) {
      if (card.set != null && card.set.id != null) {
        uniqueSets.add(card.set.id);
      }
    }
    setState(() {
      _cartasTotales = cards.length;
      _setsDiferentes = uniqueSets.length;
    });
  }

  Future<void> _loadMazos() async {
    final mazos = await _pokeapi.getMazos();
    setState(() {
      _mazos = mazos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Perfil",
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'media/profile.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: 120,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
                    Text(
                      'Cartas totales: $_cartasTotales',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sets diferentes: $_setsDiferentes',
                      style: const TextStyle(fontSize: 20),
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
                SizedBox(
                  height: 160,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _favoritas.isEmpty
                          ? const Center(
                              child: Text('No tienes cartas favoritas'))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _favoritas.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final card = _favoritas[index];
                                return AspectRatio(
                                  aspectRatio: 0.7,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: card.images?.large != null
                                        ? Image.network(card.images!.large,
                                            fit: BoxFit.cover)
                                        : Container(
                                            color: Colors.grey[300],
                                            child: const Icon(Icons.image,
                                                size: 80),
                                          ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              "Mis mazos",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Expanded(
              child: _mazos.isEmpty
                  ? const Center(child: Text('No tienes mazos'))
                  : SingleChildScrollView(
                      child: Column(
                        children: _mazos.map((mazo) {
                          return Container(
                            width: double.infinity,
                            child: DeckGroup(
                              name: mazo['nombre'] ?? 'Sin nombre',
                              tipo: 'N/A',
                              cartas: (mazo['cartas'] as List?)?.length ?? 0,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
