import 'dart:async';
import 'package:brick_breaker/components/brick.dart';
import 'package:brick_breaker/components/game_over_screen.dart';
import 'package:brick_breaker/components/game_won.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../components/ball.dart';
import '../../components/cover_screen.dart';
import '../../components/player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum Direction { up, down, left, right }

class _HomeScreenState extends State<HomeScreen> {
  double ballX = 0;
  double ballY = 0;
  var ballXDirection = Direction.left;
  var ballYDirection = Direction.down;
  double ballXIncrements = 0.01;
  double ballYIncrements = 0.01;
  bool hasGameStarted = false;
  bool isGameOver = false;
  bool gameWon = false;
  double playerX = -0.2;
  double playerWidth = 0.4;
  late FocusNode _focusNode;
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.2;
  static double numberOfBricksInRow = 4;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);
  List myBricks = [
    [firstBrickX + 0, firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 3 * (brickWidth + brickGap), firstBrickY, false],
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        updateDirection();

        moveBall();

        if (isPlayerDead()) {
          timer.cancel();
          isGameOver = true;
        }
        // is brick hit
        checkForBrokenBricks();

        int won = 0;
        for (int i = 0; i < myBricks.length; i++) {
          if (myBricks[i][2]) {
            won++;
          }
          if (won == 4) {
            gameWon = true;
            timer.cancel();
          }
        }
      },
    );
  }

  void checkForBrokenBricks() {
    for (int i = 0; i < myBricks.length; i++) {
      if (ballX >= myBricks[i][0] &&
          ballX <= myBricks[i][0] + brickWidth &&
          ballY <= myBricks[i][1] + brickHeight &&
          myBricks[i][2] == false) {
        setState(() {
          myBricks[i][2] = true;

          double leftSideDist = (myBricks[i][0] - ballX).abs();
          double rightSideDist = (myBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (myBricks[i][1] - ballY).abs();
          double bottomSideDist = (myBricks[i][1] + brickHeight - ballX).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);
          switch (min) {
            case 'left':
              ballXDirection = Direction.left;
              break;
            case 'right':
              ballXDirection = Direction.right;
              break;
            case 'top':
              ballYDirection = Direction.up;
              break;
            case 'bottom':
              ballYDirection = Direction.down;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [a, b, c, d];

    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'up';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'down';
    }
    return '';
  }

  // checking is the player is dead or not
  bool isPlayerDead() {
    // player die if the ball reaches the screen
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  // move the ball
  void moveBall() {
    setState(() {
      if (ballXDirection == Direction.left) {
        ballX -= ballXIncrements;
      } else if (ballXDirection == Direction.right) {
        ballX += ballXIncrements;
      }

      if (ballYDirection == Direction.down) {
        ballY += ballYIncrements;
      } else if (ballYDirection == Direction.up) {
        ballY -= ballYIncrements;
      }
    });
  }

  // updating the direction of the ball
  void updateDirection() {
    setState(() {
      // up
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = Direction.up;
      }
      // down
      else if (ballY <= -1) {
        ballYDirection = Direction.down;
      }
      // left
      if (ballX >= 1) {
        ballXDirection = Direction.left;
      }
      // right
      else if (ballX <= -1) {
        ballXDirection = Direction.right;
      }
    });
  }

  void moveLeft() {
    setState(() {
      if (!(playerX - 0.2 < -1)) {
        playerX -= 0.2; // Prevents the player from going off the screen
      }
    });
  }

  void moveRight() {
    setState(() {
      if (!(playerX + playerWidth >= 1)) {
        playerX += 0.2; // Prevents the player from going off the screen
      }
    });
  }

  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;
      gameWon = false;
      myBricks = [
        [firstBrickX + 0, firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 3 * (brickWidth + brickGap), firstBrickY, false],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
            moveLeft();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
            moveRight();
          }
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple[100],
          body: Center(
            child: Stack(
              children: [
                CoverScreen(
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                  gameWon: gameWon,
                ),
                GameWon(
                  gameWon: gameWon,
                  function: resetGame,
                ),
                GameOverScreen(
                  isGameOver: isGameOver,
                  function: resetGame,
                ),
                Ball(
                  ballY: ballY,
                  ballX: ballX,
                  hasGameStarted: hasGameStarted,
                  isGameOver: isGameOver,
                ),
                Player(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),
                // bricks
                Brick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: myBricks[0][0],
                  brickY: myBricks[0][1],
                  brickBroken: myBricks[0][2],
                ),
                Brick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: myBricks[1][0],
                  brickY: myBricks[1][1],
                  brickBroken: myBricks[1][2],
                ),
                Brick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: myBricks[2][0],
                  brickY: myBricks[2][1],
                  brickBroken: myBricks[2][2],
                ),
                Brick(
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickX: myBricks[3][0],
                  brickY: myBricks[3][1],
                  brickBroken: myBricks[3][2],
                ),
                // ignore: prefer_const_constructors
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: IconButton(
                    onPressed: moveRight,
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: IconButton(
                    onPressed: moveLeft,
                    icon: const Icon(Icons.arrow_back_ios_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// I’m excited to share my latest project: a Brick Breaker game developed with Flutter! 🎉 This game is not just a fun challenge but also a showcase of what Flutter can do. I implemented full move validation to ensure seamless and accurate gameplay, making every block break and paddle move count. To give the game a modern and stylish look, I integrated custom Google Fonts, and for an extra layer of visual appeal, I added the Avatar Glow effect, making the gameplay even more dynamic and engaging. This project has been a fantastic journey into the world of Flutter and game development. I’d love to hear your feedback! 🚀 #FlutterDev #GameDevelopment #MobileApps #GoogleFonts #AvatarGlow #TechInnovation
