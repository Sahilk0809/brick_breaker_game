import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
  final bool isGameOver;
  final bool gameWon;
  static var gameFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(
      color: Colors.deepPurple[600],
      letterSpacing: 0,
      fontSize: 28,
    ),
  );

  const CoverScreen({
    super.key,
    required this.hasGameStarted,
    required this.isGameOver,
    required this.gameWon,
  });

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container(
            alignment: const Alignment(0, -0.5),
            child: Text(
              isGameOver ? '' : 'Brick Breaker',
              style: gameFont.copyWith(color: Colors.deepPurple[200]),
            ),
          )
        : Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.5),
                child: Text(
                  'Brick Breaker',
                  style: gameFont,
                ),
              ),
              Container(
                alignment: const Alignment(0, 0.3),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Tap to play'),
                ),
              ),
            ],
          );
  }
}
