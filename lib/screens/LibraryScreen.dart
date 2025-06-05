import 'package:flutter/material.dart';
import 'package:pokemans/widgets/AppScaffold.dart';

class Libraryscreen extends StatefulWidget {
  static const routeName = '/library';

  Libraryscreen({super.key});

  @override
  State<Libraryscreen> createState() => _LibraryscreenState();
}

class _LibraryscreenState extends State<Libraryscreen> {
  final int imagesCount = 50;
  final int imagesPerPage = 12;
  late final int pageCount;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    pageCount = (imagesCount / imagesPerPage).ceil();
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
      int start = pageIndex * imagesPerPage;
      int end = (start + imagesPerPage).clamp(0, imagesCount);
      return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        padding: const EdgeInsets.all(8),
        children: List.generate(end - start, (i) {
          return Image.asset('media/carta.png');
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
      title: "Biblioteca",
      body: Column(
        children: [
          Text("Total de cartas: $imagesCount",
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
