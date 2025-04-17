import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DateRangeCalculatorPage extends StatefulWidget {
  const DateRangeCalculatorPage({super.key});

  @override
  State<DateRangeCalculatorPage> createState() => _DateRangeCalculatorPageState();
}

class _DateRangeCalculatorPageState extends State<DateRangeCalculatorPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  String _resultText = '';

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR', null);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        _calculateDifference();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
        _calculateDifference();
      });
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd('tr_TR').format(date);
  }

  void _calculateDifference() {
    if (_startDate == null || _endDate == null) return;

    final difference = _endDate!.difference(_startDate!);
    final years = (difference.inDays / 365).floor();
    final months = ((difference.inDays % 365) / 30).floor();
    final days = (difference.inDays % 365) % 30;
    final totalWeeks = (difference.inDays / 7).floor();
    final totalMonths = (difference.inDays / 30).floor();

    setState(() {
      _resultText = '''
Toplam: ${difference.inDays} gün
$years yıl, $months ay, $days gün
$totalWeeks hafta
$totalMonths ay
${difference.inHours} saat
${difference.inMinutes} dakika
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarih Aralığı Hesaplama'),
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
                    ListTile(
                      title: const Text('Başlangıç Tarihi'),
                      subtitle: Text(
                        _startDate != null
                            ? _formatDate(_startDate!)
                            : 'Seçilmedi',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectStartDate(context),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Bitiş Tarihi'),
                      subtitle: Text(
                        _endDate != null
                            ? _formatDate(_endDate!)
                            : 'Seçilmedi',
                        style: const TextStyle(fontSize: 18),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectEndDate(context),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_resultText.isNotEmpty)
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
                        _resultText,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.5,
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