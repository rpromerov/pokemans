import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart'; // Importa Pokeapi
import 'package:pokemans/widgets/AppScaffold.dart';
import 'package:pokemans/widgets/DeckGroup.dart';

class DecksScreen extends StatefulWidget {
  static const routeName = '/decks';

  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  final Pokeapi _pokeapi = Pokeapi();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> _mazos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMazos();
    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() => _currentPage = newPage);
      }
    });
  }

  Future<void> _loadMazos() async {
    final mazos = await _pokeapi.getMazos();
    setState(() {
      _mazos = mazos;
      _loading = false;
    });
  }

  List<Widget> _buildPages() {
    int decksPerPage = 2;
    int pageCount = (_mazos.length / decksPerPage).ceil();
    
    return List.generate(pageCount, (pageIndex) {
      int start = pageIndex * decksPerPage;
      int end = (start + decksPerPage).clamp(0, _mazos.length);
      
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: _mazos.sublist(start, end).map((mazo) {
          final cartas = mazo['cartas'] as List<String>;
          
          List<String> cardIdsToShow = [];
          if (cartas.length >= 3) {
            cardIdsToShow = cartas.sublist(0, 3);
          } else {
            cardIdsToShow = List.from(cartas);
            // Rellenar con valores vacíos si hay menos de 3 cartas
            while (cardIdsToShow.length < 3) {
              cardIdsToShow.add('');
            }
          }

          return DeckGroup(
          name: mazo['nombre'],
          tipo: 'Personalizado',
          cartas: cartas.length,
          cardIds: cardIdsToShow,
          );
        }).toList(),
      );
    });
  }

  Widget _buildPageIndicator() {
    int pageCount = (_mazos.length / 2).ceil();
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
          Text("Total de mazos: ${_mazos.length}",
              style: Theme.of(context).textTheme.titleMedium),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : PageView(
                    controller: _pageController,
                    children: _buildPages(),
                  ),
          ),
          if (!_loading) _buildPageIndicator(),
        ],
      ),
    );
  }
}
