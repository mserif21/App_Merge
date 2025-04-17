import 'package:flutter/material.dart';
import 'dart:math' as math;

class VolumeCalculatorPage extends StatelessWidget {
  const VolumeCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacim Hesaplama'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildVolumeCard(
              title: 'Küp',
              icon: Icons.crop_square,
              calculator: const _CubeVolumeCalculator(),
            ),
            const SizedBox(height: 20),
            _buildVolumeCard(
              title: 'Dikdörtgen Prizma',
              icon: Icons.view_in_ar,
              calculator: const _PrismVolumeCalculator(),
            ),
            const SizedBox(height: 20),
            _buildVolumeCard(
              title: 'Silindir',
              icon: Icons.panorama_vertical,
              calculator: const _CylinderVolumeCalculator(),
            ),
            const SizedBox(height: 20),
            _buildVolumeCard(
              title: 'Küre',
              icon: Icons.circle,
              calculator: const _SphereVolumeCalculator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeCard({
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

class _CubeVolumeCalculator extends StatefulWidget {
  const _CubeVolumeCalculator();

  @override
  _CubeVolumeCalculatorState createState() => _CubeVolumeCalculatorState();
}

class _CubeVolumeCalculatorState extends State<_CubeVolumeCalculator> {
  final _edgeController = TextEditingController();
  double _volume = 0;

  @override
  void dispose() {
    _edgeController.dispose();
    super.dispose();
  }

  void _calculateVolume() {
    final edge = double.tryParse(_edgeController.text) ?? 0;
    setState(() {
      _volume = edge * edge * edge;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _edgeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Kenar Uzunluğu',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 24),
        Text(
          'Hacim: ${_volume.toStringAsFixed(2)} m³',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _PrismVolumeCalculator extends StatefulWidget {
  const _PrismVolumeCalculator();

  @override
  _PrismVolumeCalculatorState createState() => _PrismVolumeCalculatorState();
}

class _PrismVolumeCalculatorState extends State<_PrismVolumeCalculator> {
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  double _volume = 0;

  @override
  void dispose() {
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateVolume() {
    final length = double.tryParse(_lengthController.text) ?? 0;
    final width = double.tryParse(_widthController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    setState(() {
      _volume = length * width * height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _lengthController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Uzunluk',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _widthController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Genişlik',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yükseklik',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 24),
        Text(
          'Hacim: ${_volume.toStringAsFixed(2)} m³',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _CylinderVolumeCalculator extends StatefulWidget {
  const _CylinderVolumeCalculator();

  @override
  _CylinderVolumeCalculatorState createState() => _CylinderVolumeCalculatorState();
}

class _CylinderVolumeCalculatorState extends State<_CylinderVolumeCalculator> {
  final _radiusController = TextEditingController();
  final _heightController = TextEditingController();
  double _volume = 0;

  @override
  void dispose() {
    _radiusController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateVolume() {
    final radius = double.tryParse(_radiusController.text) ?? 0;
    final height = double.tryParse(_heightController.text) ?? 0;
    setState(() {
      _volume = math.pi * radius * radius * height;
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
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _heightController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Yükseklik',
            suffixText: 'm',
          ),
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 24),
        Text(
          'Hacim: ${_volume.toStringAsFixed(2)} m³',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SphereVolumeCalculator extends StatefulWidget {
  const _SphereVolumeCalculator();

  @override
  _SphereVolumeCalculatorState createState() => _SphereVolumeCalculatorState();
}

class _SphereVolumeCalculatorState extends State<_SphereVolumeCalculator> {
  final _radiusController = TextEditingController();
  double _volume = 0;

  @override
  void dispose() {
    _radiusController.dispose();
    super.dispose();
  }

  void _calculateVolume() {
    final radius = double.tryParse(_radiusController.text) ?? 0;
    setState(() {
      _volume = (4/3) * math.pi * radius * radius * radius;
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
          onChanged: (_) => _calculateVolume(),
        ),
        const SizedBox(height: 24),
        Text(
          'Hacim: ${_volume.toStringAsFixed(2)} m³',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
} 