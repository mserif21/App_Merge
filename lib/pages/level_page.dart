import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math' as math;

class LevelPage extends StatefulWidget {
  const LevelPage({super.key});

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _x = 0;
  double _y = 0;
  bool _isCalibrated = false;
  double _calibrationX = 0;
  double _calibrationY = 0;
  bool _isHorizontalView = false;
  bool _isVibrationEnabled = true;
  bool _wasLevel = false;
  Timer? _vibrationTimer;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen((event) {
      setState(() {
        _x = event.x - _calibrationX;
        _y = event.y - _calibrationY;
        _checkLevelAndVibrate();
      });
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _vibrationTimer?.cancel();
    super.dispose();
  }

  void _calibrate() {
    setState(() {
      _calibrationX = _x;
      _calibrationY = _y;
      _isCalibrated = true;
    });
  }

  void _resetCalibration() {
    setState(() {
      _calibrationX = 0;
      _calibrationY = 0;
      _isCalibrated = false;
    });
  }

  void _checkLevelAndVibrate() {
    if (!_isVibrationEnabled) return;

    final accuracy = math.sqrt(_x * _x + _y * _y);
    final isLevel = accuracy < 0.1;

    if (isLevel && !_wasLevel) {
      HapticFeedback.heavyImpact();
      _startPeriodicVibration();
    } else if (!isLevel && _wasLevel) {
      _stopPeriodicVibration();
    }

    _wasLevel = isLevel;
  }

  void _startPeriodicVibration() {
    _vibrationTimer?.cancel();
    _vibrationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isVibrationEnabled && _wasLevel) {
        HapticFeedback.lightImpact();
      }
    });
  }

  void _stopPeriodicVibration() {
    _vibrationTimer?.cancel();
    _vibrationTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Su Terazisi'),
        actions: [
          IconButton(
            icon: Icon(_isVibrationEnabled ? Icons.vibration : Icons.notifications_off),
            onPressed: () {
              setState(() {
                _isVibrationEnabled = !_isVibrationEnabled;
                if (!_isVibrationEnabled) {
                  _stopPeriodicVibration();
                }
              });
            },
            tooltip: _isVibrationEnabled ? 'Titreşimi Kapat' : 'Titreşimi Aç',
          ),
          IconButton(
            icon: Icon(_isHorizontalView ? Icons.stay_current_portrait : Icons.stay_current_landscape),
            onPressed: () => setState(() => _isHorizontalView = !_isHorizontalView),
            tooltip: 'Görünümü Değiştir',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalibration,
            tooltip: 'Kalibrasyonu Sıfırla',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.withOpacity(0.3),
              Colors.blue.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: _isHorizontalView ? _buildHorizontalView() : _buildVerticalView(),
        ),
      ),
    );
  }

  Widget _buildVerticalView() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAngleIndicators(),
                const SizedBox(height: 40),
                _buildBubbleLevel(),
                const SizedBox(height: 40),
                _buildCalibrationButton(),
              ],
            ),
          ),
        ),
        _buildAccuracyIndicator(),
      ],
    );
  }

  Widget _buildHorizontalView() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _buildHorizontalLevel(),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildAngleCard('Açı', _x),
                    const SizedBox(height: 20),
                    _buildCalibrationButton(),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        _buildAccuracyIndicator(),
      ],
    );
  }

  Widget _buildHorizontalLevel() {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(
        painter: HorizontalLevelPainter(_x),
      ),
    );
  }

  Widget _buildAngleIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAngleCard('X Açısı', _x),
        const SizedBox(width: 20),
        _buildAngleCard('Y Açısı', _y),
      ],
    );
  }

  Widget _buildAngleCard(String title, double angle) {
    final adjustedAngle = (angle * 180 / math.pi).roundToDouble() / 10;
    final isLevel = adjustedAngle.abs() < 0.5;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 120,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${adjustedAngle.toStringAsFixed(1)}°',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isLevel ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleLevel() {
    return Container(
      width: 300,
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(
        painter: BubblePainter(_x, _y),
      ),
    );
  }

  Widget _buildCalibrationButton() {
    return ElevatedButton.icon(
      onPressed: _isCalibrated ? null : _calibrate,
      icon: const Icon(Icons.center_focus_strong),
      label: Text(_isCalibrated ? 'Kalibre Edildi' : 'Kalibre Et'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildAccuracyIndicator() {
    final accuracy = math.sqrt(_x * _x + _y * _y);
    final isLevel = accuracy < 0.1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isLevel ? Icons.check_circle : Icons.warning,
            color: isLevel ? Colors.green : Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            isLevel ? 'Düz' : 'Düz Değil',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isLevel ? Colors.green : Colors.orange,
            ),
          ),
          if (_isVibrationEnabled && isLevel) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.vibration,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ],
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final double x;
  final double y;

  BubblePainter(this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Dış çember
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.blue.withOpacity(0.2)
        ..style = PaintingStyle.fill,
    );

    // Hedef çemberler
    for (double r = radius; r > 0; r -= radius / 4) {
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..color = Colors.grey.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
    }

    // Çapraz çizgiler
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..strokeWidth = 1,
    );
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..strokeWidth = 1,
    );

    // Baloncuk
    final bubbleX = center.dx + (x * 10).clamp(-radius + 20, radius - 20);
    final bubbleY = center.dy + (y * 10).clamp(-radius + 20, radius - 20);
    final isLevel = (bubbleX - center.dx).abs() < 5 && (bubbleY - center.dy).abs() < 5;
    
    // Baloncuk gölgesi
    canvas.drawCircle(
      Offset(bubbleX + 2, bubbleY + 2),
      15,
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // Baloncuk
    canvas.drawCircle(
      Offset(bubbleX, bubbleY),
      15,
      Paint()..color = isLevel ? Colors.green : Colors.blue,
    );

    // Baloncuk parlaklığı
    canvas.drawCircle(
      Offset(bubbleX - 5, bubbleY - 5),
      5,
      Paint()..color = Colors.white.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return x != oldDelegate.x || y != oldDelegate.y;
  }
}

class HorizontalLevelPainter extends CustomPainter {
  final double angle;

  HorizontalLevelPainter(this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width;
    final height = size.height;

    // Arka plan
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(16),
      ),
      Paint()..color = Colors.grey.withOpacity(0.1),
    );

    // Merkez çizgi
    canvas.drawLine(
      Offset(0, height / 2),
      Offset(width, height / 2),
      Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..strokeWidth = 1,
    );

    // Ölçek çizgileri
    for (int i = -12; i <= 12; i++) {
      final x = center.dx + (i * width / 24);
      final isMainTick = i % 3 == 0;
      final tickHeight = isMainTick ? 30.0 : 15.0;
      final tickWidth = isMainTick ? 2.0 : 1.0;
      final tickColor = isMainTick ? Colors.black87 : Colors.grey;

      canvas.drawLine(
        Offset(x, center.dy - tickHeight / 2),
        Offset(x, center.dy + tickHeight / 2),
        Paint()
          ..color = tickColor
          ..strokeWidth = tickWidth,
      );

      if (isMainTick) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i * 5}°',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, center.dy + tickHeight / 2 + 5),
        );
      }
    }

    // Baloncuk
    final bubbleX = center.dx + (angle * width / 60).clamp(-width / 2 + 30, width / 2 - 30);
    final isLevel = (angle * 180 / math.pi).abs() < 0.5;

    // Baloncuk gölgesi
    canvas.drawCircle(
      Offset(bubbleX + 2, center.dy + 2),
      20,
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // Baloncuk
    canvas.drawCircle(
      Offset(bubbleX, center.dy),
      20,
      Paint()..color = isLevel ? Colors.green : Colors.blue,
    );

    // Baloncuk parlaklığı
    canvas.drawCircle(
      Offset(bubbleX - 7, center.dy - 7),
      7,
      Paint()..color = Colors.white.withOpacity(0.5),
    );
  }

  @override
  bool shouldRepaint(HorizontalLevelPainter oldDelegate) {
    return angle != oldDelegate.angle;
  }
} 