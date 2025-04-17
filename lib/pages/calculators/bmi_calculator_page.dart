import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/providers.dart';

class BMICalculatorPage extends StatelessWidget {
  const BMICalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VKİ Hesaplama'),
      ),
      body: Consumer<BMIProvider>(
        builder: (context, bmiProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputCard(
                  title: 'Boy',
                  value: bmiProvider.height,
                  unit: 'cm',
                  onChanged: (value) => bmiProvider.setHeight(value),
                  icon: Icons.height,
                ),
                const SizedBox(height: 20),
                _buildInputCard(
                  title: 'Kilo',
                  value: bmiProvider.weight,
                  unit: 'kg',
                  onChanged: (value) => bmiProvider.setWeight(value),
                  icon: Icons.monitor_weight,
                ),
                const SizedBox(height: 30),
                if (bmiProvider.bmi > 0) ...[
                  _buildResultCard(bmiProvider.bmi),
                  const SizedBox(height: 20),
                  _buildAdviceCard(bmiProvider.bmi),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required double value,
    required String unit,
    required Function(double) onChanged,
    required IconData icon,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: '0.0',
                suffixText: unit,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              onChanged: (value) {
                onChanged(double.tryParse(value) ?? 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(double bmi) {
    String status = _getBMIStatus(bmi);
    Color statusColor = _getStatusColor(status);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [
              statusColor.withOpacity(0.1),
              statusColor.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'VKİ Değeriniz',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              bmi.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdviceCard(double bmi) {
    String status = _getBMIStatus(bmi);
    Color statusColor = _getStatusColor(status);
    String advice = _getBMIAdvice(status);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.tips_and_updates, color: statusColor),
                const SizedBox(width: 10),
                const Text(
                  'Öneriler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              advice,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Zayıf';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Kilolu';
    return 'Obez';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Zayıf':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Kilolu':
        return Colors.orange;
      case 'Obez':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getBMIAdvice(String status) {
    switch (status) {
      case 'Zayıf':
        return 'Sağlıklı bir şekilde kilo almanız önerilir. Dengeli beslenme ve uygun egzersiz programı için bir uzmana danışabilirsiniz.';
      case 'Normal':
        return 'Tebrikler! Sağlıklı bir vücut kitle indeksine sahipsiniz. Bu durumu korumak için dengeli beslenmeye ve düzenli egzersize devam edin.';
      case 'Kilolu':
        return 'Sağlığınız için biraz kilo vermeniz yararlı olabilir. Dengeli beslenme ve düzenli egzersiz ile ideal kilonuza ulaşabilirsiniz.';
      case 'Obez':
        return 'Sağlığınız için kilo vermeniz önemlidir. Bir sağlık uzmanına danışarak size özel bir diyet ve egzersiz programı oluşturabilirsiniz.';
      default:
        return '';
    }
  }
} 