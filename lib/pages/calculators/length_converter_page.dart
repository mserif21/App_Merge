import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LengthConverterPage extends StatefulWidget {
  const LengthConverterPage({super.key});

  @override
  State<LengthConverterPage> createState() => _LengthConverterPageState();
}

class _LengthConverterPageState extends State<LengthConverterPage> {
  final _controller = TextEditingController();
  String _selectedFromUnit = 'm';
  String _selectedToUnit = 'km';
  double _result = 0;

  final Map<String, double> _units = {
    'mm': 0.001,    // milimetre
    'cm': 0.01,     // santimetre
    'dm': 0.1,      // desimetre
    'm': 1,         // metre
    'dam': 10,      // dekametre
    'hm': 100,      // hektometre
    'km': 1000,     // kilometre
    'in': 0.0254,   // inç
    'ft': 0.3048,   // feet
    'yd': 0.9144,   // yard
    'mi': 1609.344, // mil
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
        title: const Text('Uzunluk Dönüştürücü'),
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