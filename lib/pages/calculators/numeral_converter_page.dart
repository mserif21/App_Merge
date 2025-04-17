import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumeralConverterPage extends StatefulWidget {
  const NumeralConverterPage({super.key});

  @override
  State<NumeralConverterPage> createState() => _NumeralConverterPageState();
}

class _NumeralConverterPageState extends State<NumeralConverterPage> {
  final _controller = TextEditingController();
  String _selectedFromBase = '10';
  String _selectedToBase = '2';
  String _result = '';

  final Map<String, String> _bases = {
    '2': 'İkili',
    '8': 'Sekizli',
    '10': 'Onlu',
    '16': 'Onaltılı',
  };

  void _convert() {
    try {
      final input = _controller.text;
      if (input.isEmpty) {
        setState(() => _result = '');
        return;
      }

      // Önce girilen sayıyı decimal'e çevir
      int decimal;
      if (_selectedFromBase == '16') {
        decimal = int.parse(input, radix: 16);
      } else if (_selectedFromBase == '8') {
        decimal = int.parse(input, radix: 8);
      } else if (_selectedFromBase == '2') {
        decimal = int.parse(input, radix: 2);
      } else {
        decimal = int.parse(input);
      }

      // Decimal'den hedef tabana çevir
      String result;
      if (_selectedToBase == '16') {
        result = decimal.toRadixString(16).toUpperCase();
      } else if (_selectedToBase == '8') {
        result = decimal.toRadixString(8);
      } else if (_selectedToBase == '2') {
        result = decimal.toRadixString(2);
      } else {
        result = decimal.toString();
      }

      setState(() => _result = result);
    } catch (e) {
      setState(() => _result = 'Hata');
    }
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
        title: const Text('Sayı Sistemi Dönüştürücü'),
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
                              const Text('Tabandan:'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedFromBase,
                                items: _bases.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(
                                      '${entry.value} (${entry.key})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedFromBase = newValue;
                                      _convert();
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
                              const Text('Tabana:'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: _selectedToBase,
                                items: _bases.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.key,
                                    child: Text(
                                      '${entry.value} (${entry.key})',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedToBase = newValue;
                                      _convert();
                                    });
                                  }
                                },
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
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
            if (_result.isNotEmpty)
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
                        _result,
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