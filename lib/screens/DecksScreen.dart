import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart';
import 'package:pokemans/widgets/AppScaffold.dart';
import 'package:pokemans/widgets/DeckGroup.dart';
import 'package:pokemon_tcg/pokemon_tcg.dart';

class DecksScreen extends StatefulWidget {
  static const routeName = '/decks';

  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  final int decksCount = 10;
  final int decksPerPage = 3;
  late int pageCount = 1;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Map<String, List<PokemonCard>> _decks = {};

  @override
  void initState() {
    super.initState();
    _refreshDecks();
    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  Future<void> _refreshDecks() async {
    final decks = await Pokeapi().getMazos();
    setState(() {
      _decks = decks;
      pageCount = (_decks.entries.length / decksPerPage).ceil();
    });
  }

  List<Widget> _buildPages() {
    return List.generate(pageCount, (pageIndex) {
      int start = pageIndex * decksPerPage;
      int end = (start + decksPerPage).clamp(0, _decks.entries.length);
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: List.generate(end - start, (i) {
          return DeckGroup(
            name: 'Mazo ${_decks.keys.elementAt(start + i)}',
            cartas: _decks.values.elementAt(start + i).length,
            tipo: 'Tipo ${((start + i) % 3) + 1}',
            imagenesCartas: _decks.values
                .elementAt(start + i)
                .map((card) => card.images.small)
                .toList(),
          );
        }),
      );
    });
  }

  Widget _buildPageIndicator() {
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
    return AppScaffold(
      title: "Mis mazos",
      body: Column(
        children: [
          Text("Total de mazos: ${_decks.length}",
              style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _buildPages(),
            ),
          ),
          _buildPageIndicator(),
        ],
      ),
    );
  }
}
