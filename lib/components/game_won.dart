import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameWon extends StatelessWidget {
  final bool gameWon;
  final void Function()? function;
  static var gameFont = GoogleFonts.pressStart2p(
    textStyle: TextStyle(
      color: Colors.deepPurple[600],
      letterSpacing: 0,
      fontSize: 25,
    ),
  );

  const GameWon({
    super.key,
    required this.gameWon,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return gameWon
        ? Stack(
      children: [
        Container(
          alignment: const Alignment(0, -0.3),
          child: Text(
            'You Won!',
            style: gameFont,
          ),
        ),
        Container(
          alignment: const Alignment(0, 0),
          child: GestureDetector(
            onTap: function,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.deepPurple,
              ),
              child: const Text('Play Again'),
            ),
          ),
        ),
      ],
    )
        : Container();
  }
}
