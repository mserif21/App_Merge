import 'package:flutter/foundation.dart';

class BMIProvider with ChangeNotifier {
  double _height = 0;
  double _weight = 0;

  double get height => _height;
  double get weight => _weight;
  double get bmi => _height > 0 ? _weight / ((_height / 100) * (_height / 100)) : 0;

  void setHeight(double height) {
    _height = height;
    notifyListeners();
  }

  void setWeight(double weight) {
    _weight = weight;
    notifyListeners();
  }
} 