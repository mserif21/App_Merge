import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DataConverterPage extends StatefulWidget {
  const DataConverterPage({super.key});

  @override
  State<DataConverterPage> createState() => _DataConverterPageState();
}

class _DataConverterPageState extends State<DataConverterPage> {
  final _controller = TextEditingController();
  String _selectedFromUnit = 'B';
  String _selectedToUnit = 'KB';
  double _result = 0;

  final Map<String, int> _units = {
    'B': 0,   // Byte
    'KB': 1,  // Kilobyte
    'MB': 2,  // Megabyte
    'GB': 3,  // Gigabyte
    'TB': 4,  // Terabyte
    'PB': 5,  // Petabyte
  };

  void _convert() {
    final input = double.tryParse(_controller.text) ?? 0;
    final fromPower = _units[_selectedFromUnit] ?? 0;
    final toPower = _units[_selectedToUnit] ?? 0;
    final difference = fromPower - toPower;

    setState(() {
      if (difference > 0) {
        _result = input * pow(1024, difference.abs());
      } else {
        _result = input / pow(1024, difference.abs());
      }
    });
  }

  double pow(num x, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= x;
    }
    return result;
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
        title: const Text('Veri Dönüştürücü'),
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