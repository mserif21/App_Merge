import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FlashPage extends StatefulWidget {
  const FlashPage({super.key});

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> with SingleTickerProviderStateMixin {
  bool _isFlashOn = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    try {
      if (_isFlashOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
        _controller.forward();
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Flaş kullanılamıyor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flaş'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isFlashOn
                ? [Colors.yellow.withOpacity(0.3), Colors.white]
                : [
                    isDarkMode ? Colors.grey[900]! : Colors.blue[50]!,
                    isDarkMode ? Colors.black : Colors.white,
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isFlashOn
                        ? Colors.yellow
                        : isDarkMode
                            ? Colors.grey[800]
                            : Colors.grey[200],
                    boxShadow: _isFlashOn
                        ? [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.6),
                              blurRadius: 20,
                              spreadRadius: 10,
                            )
                          ]
                        : null,
                  ),
                  child: Icon(
                    _isFlashOn ? Icons.flash_on : Icons.flash_off,
                    size: 100,
                    color: _isFlashOn
                        ? Colors.white
                        : isDarkMode
                            ? Colors.white
                            : Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _toggleFlash,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFlashOn ? Colors.yellow : null,
                  foregroundColor: _isFlashOn ? Colors.black : null,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  _isFlashOn ? 'Flaşı Kapat' : 'Flaşı Aç',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 