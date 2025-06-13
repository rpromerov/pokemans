import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart';
import 'package:pokemans/widgets/AppScaffold.dart';
import 'package:pokemon_tcg/pokemon_tcg.dart';

class Libraryscreen extends StatefulWidget {
  static const routeName = '/library';

  Libraryscreen({super.key});

  @override
  State<Libraryscreen> createState() => _LibraryscreenState();
}

class _LibraryscreenState extends State<Libraryscreen> {
  final int imagesPerPage = 12;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<PokemonCard> _cards = [];
  List<String> _favoritas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
    _loadFavoritas();
    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  Future<void> _loadCards() async {
    final pokeapi = Pokeapi();
    final cards = await pokeapi.getBiblioteca();
    setState(() {
      _cards = cards;
      _loading = false;
    });
  }

  Future<void> _loadFavoritas() async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;
    final perfil = await FirebaseFirestore.instance
        .collection(usuario.uid)
        .doc('Perfil')
        .get();
    setState(() {
      _favoritas = List<String>.from(perfil['cartas favoritas'] ?? []);
    });
  }

  Future<void> _toggleFavorita(String cardId) async {
    final usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;
    final doc =
        FirebaseFirestore.instance.collection(usuario.uid).doc('Perfil');

    // Verifica si el campo existe, si no, lo inicializa
    final perfilSnapshot = await doc.get();
    var containsKey =
        perfilSnapshot.data()?.containsKey('cartas favoritas') ?? false;
    if (!containsKey) {
      await doc.set({'cartas favoritas': []}, SetOptions(merge: true));
    }

    final esFavorita = _favoritas.contains(cardId);
    setState(() {
      if (esFavorita) {
        _favoritas.remove(cardId);
      } else {
        _favoritas.add(cardId);
      }
    });
    await doc.update({
      'cartas favoritas': esFavorita
          ? FieldValue.arrayRemove([cardId])
          : FieldValue.arrayUnion([cardId])
    });
  }

  Future<void> _addCardToLibrary(String cardId) async {
    final pokeapi = Pokeapi();
    await pokeapi.db.collection(pokeapi.usuario!.uid).doc("Biblioteca").update({
      'cartas': FieldValue.arrayUnion([cardId]),
      'fecha modificacion': FieldValue.serverTimestamp(),
    });
    await _loadCards();
  }

  void _showAddCardModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<PokemonCard> searchResults = [];
        bool searching = false;
        int? addingIndex;

        return StatefulBuilder(
          builder: (context, setModalState) {
            Future<void> _searchCards(String query) async {
              setModalState(() => searching = true);
              final result = await Pokeapi().buscarCartasPorNombre(query);
              setModalState(() {
                searchResults = result;
                searching = false;
              });
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar carta',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () => _searchCards(searchController.text),
                      ),
                    ),
                    onSubmitted: _searchCards,
                  ),
                  if (searching)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (!searching)
                    SizedBox(
                      height: 400,
                      child: GridView.builder(
                        itemCount: searchResults.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                        itemBuilder: (context, index) {
                          final card = searchResults[index];
                          return Stack(
                            children: [
                              Positioned.fill(
                                child: card.images?.large != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          card.images!.large,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        color: Colors.grey[300],
                                        child:
                                            const Icon(Icons.image, size: 80),
                                      ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: addingIndex == index
                                    ? const SizedBox(
                                        width: 32,
                                        height: 32,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 3),
                                      )
                                    : Material(
                                        color: Colors.transparent,
                                        child: IconButton(
                                          icon: const Icon(Icons.add_circle,
                                              color: Colors.deepPurple,
                                              size: 32),
                                          onPressed: () async {
                                            setModalState(() {
                                              addingIndex = index;
                                            });
                                            await _addCardToLibrary(card.id);
                                            if (context.mounted)
                                              Navigator.pop(context);
                                          },
                                        ),
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildPages() {
    int pageCount = (_cards.length / imagesPerPage).ceil();
    return List.generate(pageCount, (pageIndex) {
      int start = pageIndex * imagesPerPage;
      int end = (start + imagesPerPage).clamp(0, _cards.length);
      return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),
        children: List.generate(end - start, (i) {
          final card = _cards[start + i];
          final isFav = _favoritas.contains(card.id);
          return Stack(
            children: [
              Positioned.fill(
                child: card.images != null && card.images.large != null
                    ? Image.network(card.images.large)
                    : const Icon(Icons.image_not_supported),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.amber : Colors.white,
                    size: 28,
                  ),
                  onPressed: () => _toggleFavorita(card.id),
                  tooltip:
                      isFav ? 'Quitar de favoritas' : 'Marcar como favorita',
                ),
              ),
            ],
          );
        }),
      );
    });
  }

  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index
                ? Colors.deepPurple
                : Colors.deepPurple.withOpacity(0.3),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return AppScaffold(
        title: "Biblioteca",
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    int pageCount = (_cards.length / imagesPerPage).ceil();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Text("Total de cartas: ${_cards.length}",
              style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _buildPages(),
            ),
          ),
          _buildPageIndicator(pageCount),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCardModal,
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
