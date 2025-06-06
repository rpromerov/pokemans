import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Asegúrate de tenerlo en pubspec.yaml

class DeckDetail extends StatelessWidget {
  final String name;
  final String tipo;
  final int pokemon;
  final int entrenador;
  final int energia;
  final List<String> debilidades;
  final Map<String, double> tipos;
  final List<String> imagenesCartas;

  const DeckDetail({
    super.key,
    required this.name,
    required this.tipo,
    required this.pokemon,
    required this.entrenador,
    required this.energia,
    required this.debilidades,
    required this.tipos,
    required this.imagenesCartas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle Mazo"),
        centerTitle: true,
        backgroundColor: Colors.purple[50],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(child: Text(name, style: const TextStyle(fontSize: 20))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Detalle mazo", style: TextStyle(fontSize: 18)),
              Text(tipo, style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          _buildLegenda("Cartas pokemon", pokemon, Colors.grey[300]!),
          _buildLegenda("Cartas entrenador", entrenador, Colors.red[900]!),
          _buildLegenda("Cartas energía", energia, Colors.blue),
          const SizedBox(height: 16),
          const Text("Debilidades", style: TextStyle(fontSize: 18)),
          Text(debilidades.join(" - "), style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          const Text("Tipos de Pokemon", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: tipos.entries.map((entry) {
                  final color = _getTipoColor(entry.key);
                  return PieChartSectionData(
                    value: entry.value,
                    title: '${entry.value.toInt()}%',
                    color: color,
                    radius: 50,
                    titleStyle: const TextStyle(color: Colors.white, fontSize: 14),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Cartas", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: imagenesCartas.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  imagenesCartas[index],
                  width: 100,
                  fit: BoxFit.contain,
                );
              },
              separatorBuilder: (context, index) => const SizedBox(width: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegenda(String label, int count, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 8),
        Text("$count $label"),
      ],
    );
  }

  Color _getTipoColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case "fuego":
        return Colors.orange;
      case "agua":
        return Colors.blue;
      case "planta":
        return Colors.green;
      case "psiquico":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}