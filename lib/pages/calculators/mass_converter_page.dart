import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MassConverterPage extends StatefulWidget {
  const MassConverterPage({super.key});

  @override
  State<MassConverterPage> createState() => _MassConverterPageState();
}

class _MassConverterPageState extends State<MassConverterPage> {
  final _controller = TextEditingController();
  String _selectedFromUnit = 'kg';
  String _selectedToUnit = 'g';
  double _result = 0;

  final Map<String, double> _units = {
    'mg': 0.001,    // miligram
    'g': 1,         // gram
    'kg': 1000,     // kilogram
    't': 1000000,   // ton
    'oz': 28.3495,  // ons
    'lb': 453.592,  // pound
  };

  void _convert() {
    final input = double.tryParse(_controller.text) ?? 0;
    final fromFactor = _units[_selectedFromUnit] ?? 1;
    final toFactor = _units[_selectedToUnit] ?? 1;
    
    setState(() {
      _result = input * fromFactor / toFactor;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kütle Dönüştürücü'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Değer',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _convert(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Birimden:'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedFromUnit,
                                items: _units.keys.map((String unit) {
                                  return DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedFromUnit = newValue;
                                      _convert();
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Birime:'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _selectedToUnit,
                                items: _units.keys.map((String unit) {
                                  return DropdownMenuItem<String>(
                                    value: unit,
                                    child: Text(unit),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedToUnit = newValue;
                                      _convert();
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_result > 0)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Sonuç',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${_result < 0.01 ? _result.toStringAsExponential(2) : _result.toStringAsFixed(2)} $_selectedToUnit',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 