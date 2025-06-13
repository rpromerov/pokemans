import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart';
import 'package:pokemon_tcg/pokemon_tcg.dart';

class DeckDetailScreen extends StatefulWidget {
  final String deckId;
  final String deckName;
  final List<String> cardIds;

  const DeckDetailScreen({
    super.key,
    required this.deckId,
    required this.deckName,
    required this.cardIds,
  });

  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}

class _DeckDetailScreenState extends State<DeckDetailScreen> {
  final Pokeapi _pokeapi = Pokeapi();
  List<dynamic> _cards = []; // Usamos dynamic para flexibilidad
  bool _loading = true;
  Map<String, dynamic>? _deckAnalysis;
  bool _analyzing = false;

  @override
  void initState() {
    super.initState();
    _loadDeckCards();
    _analyzeDeck();
  }

  Future<void> _analyzeDeck() async {
    setState(() => _analyzing = true);
    final types = <String, int>{};
    int pokemonCount = 0;
    int trainerCount = 0;
    int energyCount = 0;

    for (final id in widget.cardIds) {
      try {
        final card = await _pokeapi.api.getCard(id);
        final supertype = card.supertype?.toString() ?? '';
        
        if (supertype.toLowerCase().contains('pokemon')) {
          pokemonCount++;
          for (final type in card.types ?? []) {
            types[type] = (types[type] ?? 0) + 1;
          }
        } else if (supertype.toLowerCase().contains('trainer')) {
          trainerCount++;
        } else if (supertype.toLowerCase().contains('energy')) {
          energyCount++;
        }
      } catch (e) {
        debugPrint("Error analyzing card $id: $e");
      }
    }

    setState(() {
      _deckAnalysis = {
        'types': types,
        'pokemon': pokemonCount,
        'trainer': trainerCount,
        'energy': energyCount,
      };
      _analyzing = false;
    });
  }

  Future<void> _loadDeckCards() async {
    final List<dynamic> loadedCards = [];
    
    for (final cardId in widget.cardIds) {
      try {
        final card = await _pokeapi.api.getCard(cardId);
        loadedCards.add(card);
      } catch (e) {
        debugPrint("Error loading card $cardId: $e");
        // Agregar datos mínimos como fallback
        loadedCards.add({
          'name': 'Carta no disponible',
          'images': null,
          'supertype': 'Desconocido'
        });
      }
    }

    setState(() {
      _cards = loadedCards;
      _loading = false;
    });
  }

  Widget _buildDeckStats() {
    if (_analyzing || _deckAnalysis == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas del Mazo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatChip('Pokémon', _deckAnalysis!['pokemon']),
                _buildStatChip('Entrenadores', _deckAnalysis!['trainer']),
                _buildStatChip('Energías', _deckAnalysis!['energy']),
              ],
            ),
            const SizedBox(height: 10),
            if (_deckAnalysis!['types'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Distribución de tipos:'),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: (_deckAnalysis!['types'] as Map<String, int>)
                        .entries
                        .map((e) => Chip(
                              label: Text('${e.key}: ${e.value}'),
                              backgroundColor: Colors.deepPurple[100],
                            ))
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Sección de estadísticas
                _buildDeckStats(),
                
                // Contador de cartas
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        'Cartas: ${_cards.length}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () {
                          _loadDeckCards();
                          _analyzeDeck();
                        },
                      ),
                    ],
                  ),
                ),
                
                // Lista de cartas
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      
                      // Manejar tanto objetos PokemonCard como mapas
                      final cardName = card is PokemonCard ? card.name : card['name'];
                      final imageUrl = card is PokemonCard 
                          ? card.images?.large 
                          : card['images']?['large'];
                      final supertype = card is PokemonCard 
                          ? card.supertype?.toString() 
                          : card['supertype'];

                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: imageUrl != null
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.contain,
                                      )
                                    : const Icon(Icons.image_not_supported),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                cardName ?? 'Nombre desconocido',
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (supertype != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  supertype,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}