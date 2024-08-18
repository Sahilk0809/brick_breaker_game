import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final double playerX;
  final double playerWidth;

  const Player({
    super.key,
    required this.playerX,
    required this.playerWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * playerX + playerWidth)/(2 - playerWidth), 0.9),
      child: Container(
        height: 10,
        width: MediaQuery.of(context).size.width * playerWidth / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
