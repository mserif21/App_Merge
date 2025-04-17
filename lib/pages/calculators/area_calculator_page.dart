import 'package:flutter/material.dart';
import 'dart:math' as math;

class AreaCalculatorPage extends StatelessWidget {
  const AreaCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alan Hesaplama'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildAreaCard(
              title: 'Dikdörtgen',
              icon: Icons.rectangle_outlined,
              calculator: const _RectangleAreaCalculator(),
            ),
            const SizedBox(height: 20),
            _buildAreaCard(
              title: 'Üçgen',
              icon: Icons.change_history,
              calculator: const _TriangleAreaCalculator(),
            ),
            const SizedBox(height: 20),
            _buildAreaCard(
              title: 'Daire',
              icon: Icons.circle_outlined,
              calculator: const _CircleAreaCalculator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard({
    required String title,
    required IconData icon,
    required Widget calculator,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 16),
            Text(title),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: calculator,
          ),
        ],
      ),
    );
  }
}

class _RectangleAreaCalculator extends StatefulWidget {
  const _RectangleAreaCalculator();

  @override
  _RectangleAreaCalculatorState createState() => _RectangleAreaCalculatorState();
}

class _RectangleAreaCalculatorState extends State<_RectangleAreaCalculator> {
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  double _area = 0;

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateArea() {
    final width = double.tryParse(_widthController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    setState(() {
      _area = width * height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _widthController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Genişlik',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateArea(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yükseklik',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateArea(),
        ),
        const SizedBox(height: 24),
        Text(
          'Alan: ${_area.toStringAsFixed(2)} m²',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _TriangleAreaCalculator extends StatefulWidget {
  const _TriangleAreaCalculator();

  @override
  _TriangleAreaCalculatorState createState() => _TriangleAreaCalculatorState();
}

class _TriangleAreaCalculatorState extends State<_TriangleAreaCalculator> {
  final _baseController = TextEditingController();
  final _heightController = TextEditingController();
  double _area = 0;

  @override
  void dispose() {
    _baseController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateArea() {
    final base = double.tryParse(_baseController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    setState(() {
      _area = (base * height) / 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _baseController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Taban',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateArea(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yükseklik',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateArea(),
        ),
        const SizedBox(height: 24),
        Text(
          'Alan: ${_area.toStringAsFixed(2)} m²',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CircleAreaCalculator extends StatefulWidget {
  const _CircleAreaCalculator();

  @override
  _CircleAreaCalculatorState createState() => _CircleAreaCalculatorState();
}

class _CircleAreaCalculatorState extends State<_CircleAreaCalculator> {
  final _radiusController = TextEditingController();
  double _area = 0;

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _calculateArea() {
    final radius = double.tryParse(_radiusController.text) ?? 0;
    setState(() {
      _area = math.pi * radius * radius;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _radiusController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yarıçap',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateArea(),
        ),
        const SizedBox(height: 24),
        Text(
          'Alan: ${_area.toStringAsFixed(2)} m²',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
} 