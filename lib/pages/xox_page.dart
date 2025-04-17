import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class XOXPage extends StatelessWidget {
  const XOXPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('XOX Oyunu'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.3),
              Colors.blue.withOpacity(0.1),
            ],
          ),
        ),
        child: Consumer<XOXProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusCard(context, provider),
                  const SizedBox(height: 32),
                  _buildGameBoard(context, provider),
                  const SizedBox(height: 32),
                  _buildNewGameButton(context, provider),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, XOXProvider provider) {
    String message;
    Color color;
    IconData icon;

    if (provider.winner.isEmpty) {
      message = '${provider.isXTurn ? "X" : "O"} Sırası';
      color = provider.isXTurn ? Colors.blue : Colors.red;
      icon = provider.isXTurn ? Icons.close : Icons.circle_outlined;
    } else if (provider.winner == 'Berabere') {
      message = 'Berabere!';
      color = Colors.orange;
      icon = Icons.balance;
    } else {
      message = '${provider.winner} Kazandı!';
      color = provider.winner == 'X' ? Colors.blue : Colors.red;
      icon = provider.winner == 'X' ? Icons.close : Icons.circle_outlined;
    }

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.2),
              color.withOpacity(0.1),
            ],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameBoard(BuildContext context, XOXProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return _buildCell(context, index, provider);
        },
      ),
    );
  }

  Widget _buildCell(BuildContext context, int index, XOXProvider provider) {
    final value = provider.board[index];
    final isWinningCell = provider.winningCombination?.contains(index) ?? false;

    return GestureDetector(
      onTap: () => provider.makeMove(index),
      child: Container(
        decoration: BoxDecoration(
          color: isWinningCell ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: value.isEmpty
                ? null
                : Icon(
                    value == 'X' ? Icons.close : Icons.circle_outlined,
                    key: ValueKey(value),
                    size: 40,
                    color: value == 'X' ? Colors.blue : Colors.red,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewGameButton(BuildContext context, XOXProvider provider) {
    return ElevatedButton(
      onPressed: provider.resetGame,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.refresh),
          SizedBox(width: 8),
          Text(
            'Yeni Oyun',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
} 