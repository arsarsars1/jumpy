import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'enums.dart';

class GameController {
  int score = 0;
  double height = 0;
  FlameGame? currentGameRef;
  GameAction action = GameAction.idle;
  bool isJumping = false;
  ValueNotifier<GameStatus> gameStatus =
      ValueNotifier<GameStatus>(GameStatus.pause);
  ValueNotifier<int> coinsCollected = ValueNotifier<int>(0);

  void updateHeight(double value) {
    height = value;
    print("JUMP");
    print(height);
    print("JUMP Finished");
  }

  void increaseScore() {
    score += 1;
  }

  void resetScore() {
    score = 0;
  }

  void releaseControl() {
    action = GameAction.idle;
  }

  void setAction(GameAction updatedAction) {
    action = updatedAction;
  }

  void setGameState(GameStatus updatedState) {
    gameStatus.value = updatedState;
  }
}
