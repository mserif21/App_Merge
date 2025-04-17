import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'calculators/bmi_calculator_page.dart';
import 'calculators/age_calculator_page.dart';
import 'calculators/area_calculator_page.dart';
import 'calculators/volume_calculator_page.dart';
import 'calculators/data_converter_page.dart';
import 'calculators/length_converter_page.dart';
import 'calculators/mass_converter_page.dart';
import 'calculators/numeral_converter_page.dart';
import 'calculators/speed_converter_page.dart';
import 'calculators/time_converter_page.dart';
import 'calculators/temperature_converter_page.dart';
import 'calculators/discount_calculator_page.dart';
import 'calculators/date_range_calculator_page.dart';


class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _input = '';
  String _result = '';
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesaplama Araçları'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Hesap Makinesi'),
            Tab(text: 'Diğer Hesaplamalar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalculator(),
          _buildOtherCalculators(),
        ],
      ),
    );
  }

  // Diğer hesaplamalar grid görünümü
  Widget _buildOtherCalculators() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.0,
      children: [
        _buildCalculatorCard(
          'VKİ\nHesaplama',
          Icons.monitor_weight,
          Colors.green,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BMICalculatorPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Yaş\nHesaplama',
          Icons.calendar_today,
          Colors.blue,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AgeCalculatorPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Alan\nHesaplama',
          Icons.square_foot,
          Colors.orange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AreaCalculatorPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Hacim\nHesaplama',
          Icons.view_in_ar,
          Colors.purple,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VolumeCalculatorPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Veri\nDönüştürücü',
          Icons.storage,
          Colors.indigo,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DataConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Uzunluk\nDönüştürücü',
          Icons.straighten,
          Colors.brown,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LengthConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Kütle\nDönüştürücü',
          Icons.scale,
          Colors.teal,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MassConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Sayı\nSistemi',
          Icons.numbers,
          Colors.deepPurple,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NumeralConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Hız\nDönüştürücü',
          Icons.speed,
          Colors.red,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SpeedConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Zaman\nDönüştürücü',
          Icons.timer,
          Colors.deepOrange,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimeConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Sıcaklık\nDönüştürücü',
          Icons.thermostat,
          Colors.amber,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TemperatureConverterPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'İndirim\nHesaplama',
          Icons.discount,
          Colors.pink,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DiscountCalculatorPage(),
            ),
          ),
        ),
        _buildCalculatorCard(
          'Tarih\nAralığı',
          Icons.date_range,
          Colors.cyan,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DateRangeCalculatorPage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color.withOpacity(0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 32,
                color: color,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hesap makinesi widget'ı
  Widget _buildCalculator() {
    return Column(
      children: [
        // Ekran
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(24),
            width: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _input,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_result.isNotEmpty && _input != _result)
                  Text(
                    '= $_result',
                    style: TextStyle(
                      fontSize: 24,
                      color: _hasError ? Colors.red : Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Tuş takımı
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildButtonRow(['C', '⌫', '%', '÷']),
              _buildButtonRow(['7', '8', '9', '×']),
              _buildButtonRow(['4', '5', '6', '-']),
              _buildButtonRow(['1', '2', '3', '+']),
              _buildButtonRow(['0', '.', '=', '=']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: buttons.map((button) {
          bool isDouble = button == '=';
          bool isOperator = '+-×÷%'.contains(button);
          bool isClear = button == 'C';
          bool isBackspace = button == '⌫';

          return Expanded(
            flex: isDouble ? 2 : 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: MaterialButton(
                onPressed: () => _onButtonPressed(button),
                height: 64,
                color: _getButtonColor(button),
                textColor: _getTextColor(button),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  button,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getButtonColor(String button) {
    if ('+-×÷%'.contains(button)) {
      return Colors.blue;
    }
    if (button == 'C') {
      return Colors.red.shade400;
    }
    if (button == '⌫') {
      return Colors.orange;
    }
    if (button == '=') {
      return Colors.green;
    }
    return Colors.grey.shade200;
  }

  Color _getTextColor(String button) {
    if ('+-×÷%=C⌫'.contains(button)) {
      return Colors.white;
    }
    return Colors.black;
  }

  void _onButtonPressed(String value) {
    setState(() {
      _hasError = false;

      switch (value) {
        case 'C':
          _input = '';
          _result = '';
          break;
        case '⌫':
          if (_input.isNotEmpty) {
            _input = _input.substring(0, _input.length - 1);
          }
          break;
        case '=':
          try {
            _result = _calculateResult();
            _input = _result;
          } catch (e) {
            _hasError = true;
            _result = 'Hata';
          }
          break;
        default:
          _input += value;
      }
    });
  }

  String _calculateResult() {
    String expression = _input;
    expression = expression.replaceAll('×', '*');
    expression = expression.replaceAll('÷', '/');

    List<String> numbers = expression.split(RegExp(r'[+\-*/]'));
    List<String> operators = expression.split(RegExp(r'[0-9.]')).where((e) => e.isNotEmpty).toList();

    if (numbers.isEmpty) return '0';

    double result = double.parse(numbers[0]);
    for (int i = 0; i < operators.length; i++) {
      double nextNum = double.parse(numbers[i + 1]);
      switch (operators[i]) {
        case '+':
          result += nextNum;
          break;
        case '-':
          result -= nextNum;
          break;
        case '*':
          result *= nextNum;
          break;
        case '/':
          if (nextNum == 0) throw Exception('Sıfıra bölünemez');
          result /= nextNum;
          break;
      }
    }

    if (result == result.toInt()) {
      return result.toInt().toString();
    }
    return result.toStringAsFixed(2);
  }
} 