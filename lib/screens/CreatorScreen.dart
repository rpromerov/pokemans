import 'package:flutter/material.dart';
import 'package:pokemans/widgets/AppScaffold.dart';

class CreatorScreen extends StatefulWidget {
  static const routeName = '/creator';

  const CreatorScreen({super.key});

  @override
  State<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends State<CreatorScreen> {
  final int imagesCount = 38;

  final int imagesPerPage = 16;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AppScaffold(
      title: 'Creador',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar carta',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    // Clear search logic here
                  },
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Center(
            child: Text(
              'Elige tres cartas para crear tu mazo',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                child: SizedBox(
                  height: size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.asset(
                      'media/carta.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.asset(
                      'media/carta.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SizedBox(
                  height: size.height * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Image.asset(
                      'media/carta.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mazo actual',
                    style: Theme.of(context).textTheme.titleMedium),
                Text('Cartas seleccionadas: $imagesCount',
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
          Expanded(
              child: PageView.builder(
            itemCount: (imagesCount / imagesPerPage).ceil(),
            itemBuilder: (context, pageIndex) {
              int start = pageIndex * imagesPerPage;
              int end = (start + imagesPerPage).clamp(0, imagesCount);
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 1,
                ),
                itemCount: end - start,
                itemBuilder: (context, index) {
                  return Image.asset('media/carta.png');
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
