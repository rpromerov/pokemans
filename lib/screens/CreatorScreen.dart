import 'package:flutter/material.dart';
import 'package:pokemans/services/PokeApi.dart';
import 'package:pokemans/widgets/AppScaffold.dart';
import 'package:pokemon_tcg/pokemon_tcg.dart';

class CreatorScreen extends StatefulWidget {
  static const routeName = '/creator';

  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  List<PokemonCard> _biblioCards = [];
  final List<PokemonCard> _filteredCards = [];
  final List<PokemonCard> _mazoCards = [];
  PokemonCard? _selectedCard;
  bool _loading = true;
  final int imagesCount = 38;
  final int imagesPerPage = 12;
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    // Es importante limpiar el controlador cuando el widget se destruye
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final pokeapi = Pokeapi();
    final cards = await pokeapi.getBiblioteca();
    setState(() {
      _biblioCards = cards;
      _loading = false;
    });
  }

  List<Widget> _buildPages() {
    int pageCount = (_mazoCards.length / imagesPerPage).ceil();
    return List.generate(pageCount, (pageIndex) {
      int start = pageIndex * imagesPerPage;
      int end = (start + imagesPerPage).clamp(0, _mazoCards.length);
      return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),
        children: List.generate(end - start, (i) {
          final card = _mazoCards[start + i];
          return card.images != null && card.images.large != null
              ? Image.network(card.images.large)
              : const Icon(Icons.image_not_supported);
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

  Future<String?> _mostrarDialogoDeTexto(BuildContext context) {
    // Controlador para acceder al texto del TextField.
    final TextEditingController textController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ingresa un nombre'),
          content: TextField(
            controller: textController,
            autofocus:
                true, // Pone el foco en el campo de texto automáticamente.
            decoration: const InputDecoration(
              hintText: 'Ej: Mazo de Fuego',
            ),
          ),
          actions: <Widget>[
            // BOTÓN DE CANCELAR
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                // Cierra el modal sin devolver ningún dato.
                Navigator.of(context).pop();
              },
            ),
            // BOTÓN DE GUARDAR
            ElevatedButton(
              child: const Text('Guardar'),
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int pageCount = (_mazoCards.length / imagesPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Creador'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Autocomplete<PokemonCard>(
              displayStringForOption: (PokemonCard option) => '',
              optionsBuilder: (TextEditingValue textEditingValue) {
                // Si el campo está vacío, no mostramos ninguna sugerencia
                if (textEditingValue.text == '') {
                  return const Iterable<PokemonCard>.empty();
                }
                // Filtramos la lista basándonos en el texto de entrada
                return _biblioCards.where((PokemonCard card) {
                  return card.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 200.0, // Limita la altura de la lista
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final PokemonCard option = options.elementAt(index);
                          return InkWell(
                            onTap: () {
                              onSelected(option);
                            },
                            child: ListTile(
                              leading: option.images.large != null
                                  ? Image.network(option.images.large)
                                  : const Icon(Icons.image_not_supported),
                              title: Text(option.name),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              fieldViewBuilder: (context, textEditingController, focusNode,
                  onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                      hintText: 'Escribe el nombre de una carta',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: const Icon(Icons.arrow_drop_down)),
                );
              },
              onSelected: (PokemonCard selection) {
                setState(() {
                  _mazoCards.add(selection);
                  _filteredCards.remove(selection);
                  _selectedCard = selection;
                });
                debugPrint('Has seleccionado la carta: ${selection.name}');
              },
            ),
          ),
          Center(
            child: Text(
              'Se necesitan al menos 30 cartas para crear un mazo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (_selectedCard != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: size.height * 0.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Image.network(_selectedCard!.images.large),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCard!.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Tipo: ${_selectedCard!.supertype.type}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (_selectedCard!.types.isNotEmpty)
                        Text(
                          'Tipo: ${_selectedCard!.types[0].type}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      Row(
                        children: [
                          IconButton.filled(
                              onPressed: () {
                                setState(() {
                                  _mazoCards.add(_selectedCard!);
                                });
                              },
                              icon: const Icon(Icons.add)),
                          IconButton.filled(
                              onPressed: () {
                                setState(() {
                                  _mazoCards.remove(_selectedCard!);
                                });
                              },
                              icon: const Icon(Icons.remove)),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mazo actual',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('Cartas seleccionadas: ${_mazoCards.length}',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
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
        onPressed: () async {
          if (_mazoCards.length > 30) {
            final nombre = await _mostrarDialogoDeTexto(context);
            if (nombre != null) {
              Pokeapi().crearMazo(_mazoCards, nombre);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('El mazo debe tener al menos 30 cartas'),
              ),
            );
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
