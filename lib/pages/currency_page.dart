import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _amountController = TextEditingController();
  String _selectedCurrency = 'TRY';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(
      () => context.read<CurrencyProvider>().fetchRates(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Döviz & Altın'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Döviz'),
            Tab(text: 'Altın'),
            Tab(text: 'Kripto'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCurrencyList(),
          _buildGoldList(),
          _buildCryptoList(),
        ],
      ),
    );
  }

  Widget _buildCurrencyList() {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.error,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchRates(),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final rates = provider.rates;
        final currencies = ['USD', 'EUR', 'GBP', 'TRY'];

        return Column(
          children: [
            _buildConverter(rates, currencies),
            Expanded(
              child: RefreshIndicator(
                onRefresh: provider.fetchRates,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: currencies.length - 1, // TRY hariç
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final rate = rates[currency];
                    return Card(
                      child: ListTile(
                        leading: _getCurrencyIcon(currency),
                        title: Text(currency),
                        subtitle: Text(_getCurrencyName(currency)),
                        trailing: Text(
                          rate != null ? '${(1 / rate).toStringAsFixed(2)} ₺' : 'N/A',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConverter(Map<String, double> rates, List<String> currencies) {
    return Column(
      children: [
        // Para Birimi Seçici
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Text(
                      _selectedCurrency,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
                subtitle: Text(
                  _getCurrencyName(_selectedCurrency),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => _buildCurrencyPicker(currencies),
                  );
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        const Divider(height: 32),
        // Dönüşüm Sonuçları
        _buildConversionResults(rates),
      ],
    );
  }

  Widget _buildCurrencyPicker(List<String> currencies) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Para Birimi Seçin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currencies.length,
              itemBuilder: (context, index) {
                final currency = currencies[index];
                return ListTile(
                  leading: currency != 'TRY' ? _getCurrencyIcon(currency) : null,
                  title: Text(currency),
                  subtitle: Text(_getCurrencyName(currency)),
                  selected: currency == _selectedCurrency,
                  onTap: () {
                    setState(() => _selectedCurrency = currency);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversionResults(Map<String, double> rates) {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount == 0) return const SizedBox();

    List<Widget> results = [];
    if (_selectedCurrency == 'TRY') {
      for (var currency in ['USD', 'EUR', 'GBP']) {
        final rate = rates[currency];
        if (rate != null) {
          final converted = amount * rate;
          results.add(_buildConversionResult(amount, 'TRY', converted, currency));
        }
      }
    } else {
      final rate = rates[_selectedCurrency];
      if (rate != null) {
        final converted = amount / rate;
        results.add(_buildConversionResult(amount, _selectedCurrency, converted, 'TRY'));
      }
    }

    return Column(children: results);
  }

  Widget _buildConversionResult(
    double fromAmount,
    String fromCurrency,
    double toAmount,
    String toCurrency,
  ) {
    return ListTile(
      title: Text(
        toCurrency,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(_getCurrencyName(toCurrency)),
      trailing: Text(
        toAmount.toStringAsFixed(4),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGoldList() {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.error,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchRates(),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final goldRates = provider.goldRates;
        final goldTypes = ['GRAM', 'CEYREK', 'YARIM', 'TAM', 'RESAT'];

        return RefreshIndicator(
          onRefresh: provider.fetchRates,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goldTypes.length,
            itemBuilder: (context, index) {
              final goldType = goldTypes[index];
              final rate = goldRates[goldType];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.monetization_on, color: Colors.amber),
                  title: Text(_getGoldName(goldType)),
                  trailing: Text(
                    rate != null ? '${rate.toStringAsFixed(2)} ₺' : 'N/A',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCryptoList() {
    return Consumer<CurrencyProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.error,
                  style: TextStyle(color: Colors.red[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.fetchRates(),
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          );
        }

        final cryptoRates = provider.cryptoRates;
        final cryptoTypes = ['BTC', 'ETH', 'BNB', 'XRP', 'DOGE'];

        return RefreshIndicator(
          onRefresh: provider.fetchRates,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cryptoTypes.length,
            itemBuilder: (context, index) {
              final cryptoType = cryptoTypes[index];
              final rate = cryptoRates[cryptoType];
              return Card(
                child: ListTile(
                  leading: _getCryptoIcon(cryptoType),
                  title: Text(cryptoType),
                  subtitle: Text(_getCryptoName(cryptoType)),
                  trailing: Text(
                    rate != null ? '${rate.toStringAsFixed(2)} ₺' : 'N/A',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  String _getGoldName(String goldType) {
    switch (goldType) {
      case 'GRAM':
        return 'Gram Altın';
      case 'CEYREK':
        return 'Çeyrek Altın';
      case 'YARIM':
        return 'Yarım Altın';
      case 'TAM':
        return 'Tam Altın';
      case 'RESAT':
        return 'Reşat Altın';
      default:
        return goldType;
    }
  }

  Widget _getCurrencyIcon(String currency) {
    IconData icon;
    switch (currency) {
      case 'USD':
        icon = Icons.attach_money;
        break;
      case 'EUR':
        icon = Icons.euro;
        break;
      case 'GBP':
        icon = Icons.currency_pound;
        break;
      default:
        icon = Icons.money;
    }
    return Icon(icon, size: 30);
  }

  String _getCurrencyName(String currency) {
    switch (currency) {
      case 'USD':
        return 'Amerikan Doları';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'İngiliz Sterlini';
      default:
        return currency;
    }
  }

  Widget _getCryptoIcon(String crypto) {
    Color iconColor;
    switch (crypto) {
      case 'BTC':
        iconColor = Colors.orange;
        break;
      case 'ETH':
        iconColor = Colors.blue;
        break;
      case 'BNB':
        iconColor = Colors.yellow;
        break;
      case 'XRP':
        iconColor = Colors.black;
        break;
      case 'DOGE':
        iconColor = Colors.amber;
        break;
      default:
        iconColor = Colors.grey;
    }
    return Icon(Icons.currency_bitcoin, size: 30, color: iconColor);
  }

  String _getCryptoName(String crypto) {
    switch (crypto) {
      case 'BTC':
        return 'Bitcoin';
      case 'ETH':
        return 'Ethereum';
      case 'BNB':
        return 'Binance Coin';
      case 'XRP':
        return 'Ripple';
      case 'DOGE':
        return 'Dogecoin';
      default:
        return crypto;
    }
  }
} 