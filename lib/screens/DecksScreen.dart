import 'package:flutter/material.dart';
import 'package:pokemans/widgets/AppScaffold.dart';
import 'package:pokemans/widgets/DeckGroup.dart';

class DecksScreen extends StatefulWidget {
  static const routeName = '/decks';

  const DecksScreen({super.key});

  @override
  State<DecksScreen> createState() => _DecksScreenState();
}

class _DecksScreenState extends State<DecksScreen> {
  final int decksCount = 10;
  final int decksPerPage = 2;
  late final int pageCount;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageCount = (decksCount / decksPerPage).ceil();
    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  List<Widget> _buildPages() {
    return List.generate(pageCount, (pageIndex) {
      int start = pageIndex * decksPerPage;
      int end = (start + decksPerPage).clamp(0, decksCount);
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: List.generate(end - start, (i) {
          return DeckGroup(
            name: 'Mazo ${start + i + 1}',
            tipo: 'Tipo ${((start + i) % 3) + 1}',
            cartas: 40 + (start + i) * 2,
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
          Text("Total de mazos: $decksCount",
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
