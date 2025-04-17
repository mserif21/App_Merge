import 'package:flutter/foundation.dart';

class XOXProvider with ChangeNotifier {
  List<String> _board = List.filled(9, '');
  bool _isXTurn = true;
  String _winner = '';
  List<int>? _winningCombination;

  List<String> get board => _board;
  bool get isXTurn => _isXTurn;
  String get winner => _winner;
  List<int>? get winningCombination => _winningCombination;

  void makeMove(int index) {
    if (_board[index].isEmpty && _winner.isEmpty) {
      _board[index] = _isXTurn ? 'X' : 'O';
      _checkWinner();
      _isXTurn = !_isXTurn;
      notifyListeners();
    }
  }

  void _checkWinner() {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Yatay
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Dikey
      [0, 4, 8], [2, 4, 6], // Çapraz
    ];

    for (final combination in winningCombinations) {
      if (_board[combination[0]].isNotEmpty &&
          _board[combination[0]] == _board[combination[1]] &&
          _board[combination[0]] == _board[combination[2]]) {
        _winner = _board[combination[0]];
        _winningCombination = combination;
        return;
      }
    }

    if (!_board.contains('') && _winner.isEmpty) {
      _winner = 'Berabere';
    }
  }

  void resetGame() {
    _board = List.filled(9, '');
    _isXTurn = true;
    _winner = '';
    _winningCombination = null;
    notifyListeners();
  }
} 