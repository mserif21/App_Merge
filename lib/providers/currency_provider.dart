import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CurrencyProvider with ChangeNotifier {
  Map<String, double> _rates = {};
  Map<String, double> _goldRates = {};
  Map<String, double> _cryptoRates = {};
  bool _isLoading = false;
  String _error = '';

  Map<String, double> get rates => _rates;
  Map<String, double> get goldRates => _goldRates;
  Map<String, double> get cryptoRates => _cryptoRates;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchRates() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/TRY'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _rates = Map<String, double>.from(
          data['rates'].map((key, value) => MapEntry(key, value.toDouble())),
        );
        _calculateGoldRates();
        await _fetchCryptoRates();
      } else {
        _error = 'Döviz kurları alınamadı';
      }
    } catch (e) {
      _error = 'Bir hata oluştu: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchCryptoRates() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,binancecoin,ripple,dogecoin&vs_currencies=try'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _cryptoRates = {
          'BTC': data['bitcoin']['try'].toDouble(),
          'ETH': data['ethereum']['try'].toDouble(),
          'BNB': data['binancecoin']['try'].toDouble(),
          'XRP': data['ripple']['try'].toDouble(),
          'DOGE': data['dogecoin']['try'].toDouble(),
        };
      } else {
        _error = 'Kripto para kurları alınamadı';
      }
    } catch (e) {
      _error = 'Kripto para kurları alınırken hata oluştu: $e';
    }
  }

  void _calculateGoldRates() {
    const gramGoldPrice = 2000.0;
    
    _goldRates = {
      'GRAM': gramGoldPrice,
      'CEYREK': gramGoldPrice * 1.75,
      'YARIM': gramGoldPrice * 3.5,
      'TAM': gramGoldPrice * 7.0,
      'RESAT': gramGoldPrice * 7.2,
    };
  }
} 