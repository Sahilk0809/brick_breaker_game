import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  final double ballX;
  final double ballY;
  final bool hasGameStarted;
  final bool isGameOver;

  const Ball({
    super.key,
    required this.ballY,
    required this.ballX,
    required this.hasGameStarted,
    required this.isGameOver,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return hasGameStarted
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              height: height * 0.02,
              width: width * 0.04,
              decoration: BoxDecoration(
                color: isGameOver ? Colors.deepPurple : Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          )
        : Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              glowRadiusFactor: 5.0,
              child: Material(
                elevation: 8.0,
                shape: const CircleBorder(),
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  radius: 7.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple,
                    ),
                    width: width * 0.02,
                    height: height * 0.15,
                  ),
                ),
              ),
            ),
          );
  }
}
