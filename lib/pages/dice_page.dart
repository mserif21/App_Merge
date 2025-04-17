import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:math';

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with SingleTickerProviderStateMixin {
  final _random = Random();
  int _dice1 = 1;
  int _dice2 = 1;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<int> _history = [];
  bool _isRolling = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/dice_roll.mp3');
      await _audioPlayer.setVolume(1.0);
    } catch (e) {
      debugPrint('Ses yüklenirken hata: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _rollDice() async {
    if (_isRolling) return;

    setState(() => _isRolling = true);
    _controller.reset();
    _controller.forward();

    // Zar sesi çal
    try {
      await _audioPlayer.seek(Duration.zero);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint('Ses çalınırken hata: $e');
    }

    // Zar atma animasyonu sırasında rastgele değerler göster
    for (int i = 0; i < 10; i++) {
      if (mounted) {
        setState(() {
          _dice1 = _random.nextInt(6) + 1;
          _dice2 = _random.nextInt(6) + 1;
        });
      }
      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Son değerleri belirle
    setState(() {
      _dice1 = _random.nextInt(6) + 1;
      _dice2 = _random.nextInt(6) + 1;
      _history.insert(0, _dice1 + _dice2);
      if (_history.length > 5) _history.removeLast();
      _isRolling = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zar Atma'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode
                ? [
                    Colors.indigo.withOpacity(0.3),
                    Colors.black,
                  ]
                : [
                    Colors.blue.withOpacity(0.3),
                    Colors.white,
                  ],
            stops: const [0.0, 0.8],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDice(_dice1),
                    const SizedBox(width: 24),
                    _buildDice(_dice2),
                  ],
                ),
              ),
            ),
            _buildRollButton(),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildDice(int value) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRollButton() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return ElevatedButton(
      onPressed: _isRolling ? null : _rollDice,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        backgroundColor: isDarkMode ? Colors.indigo : Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_isRolling ? Icons.hourglass_empty : Icons.casino),
          const SizedBox(width: 8),
          Text(
            _isRolling ? 'Atılıyor...' : 'Zar At',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.grey[900]!.withOpacity(0.9) 
            : Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Son Atışlar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _history.map((number) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDarkMode 
                      ? Colors.indigo.withOpacity(0.2) 
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  number.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
} 