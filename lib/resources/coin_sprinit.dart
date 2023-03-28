import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jumpy/export.dart';

class CoinSpriteComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  CoinSpriteComponent(this.parallax, this.world,
      {this.initPosition,
      this.midWayCallback,
      this.onRemoved,
      required this.coinId})
      : velocity = Vector2.zero(),
        super(size: Vector2(7.w, 7.w));
  final Parallax parallax;
  final Vector2? initPosition;
  final World world;
  final Vector2 velocity;
  final double runSpeed = 200.0;
  final ValueChanged? midWayCallback;
  final ValueChanged? onRemoved;
  final String coinId;
  late AudioPool coinSound;
  @override
  Future<void>? onLoad() async {
    coinSound = await AudioPool.create('audio/coin.mp3', maxPlayers: 1);
    int xOffset = Random().nextInt(30) + 20;
    bool shouldFloat = Random().nextBool();
    int yOffset =
        shouldFloat ? Random().nextInt(10) + -3 : Random().nextInt(20) + 15;

    priority = 5;
    x = xOffset.h;
    y = yOffset.w;
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('coin.png'), srcSize: Vector2(20, 20));
    // final sprites =
    //     [1, 2, 3, 4, 5, 6].map((i) => Sprite.load('rotating_saw_0$i.png'));
    // final spriteAnimation = SpriteAnimation.spriteList(
    //   await Future.wait(sprites),
    //   stepTime: 0.08,
    // );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1);
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void onRemove() {
    if (onRemoved != null) {
      onRemoved!(coinId);
    }
    super.onRemove();
  }

  @override
  void update(double dt) {
    GameController gameController = GetIt.instance<GameController>();
    GameAction action = gameController.action;
    bool isJumping = gameController.isJumping;
    // x += parallax.currentOffset().x;
    // if (action.isMovingRight) {
    //   // x -= parallax.currentOffset().x * parallax.baseVelocity.x / 5;
    //   x -= parallax.currentOffset().x + 4;
    // } else if (action.isMovingLeft) {
    //   // x -= parallax.currentOffset().x * parallax.baseVelocity.x / 2;
    //   x += parallax.currentOffset().x + 4;
    // }
    if (gameController.gameStatus.value == GameStatus.start) {
      x -= parallax.currentOffset().x + 4;
    }

    if (x <= 240 && midWayCallback != null) {
      midWayCallback!(true);
    }
    // print('Parallex Offset : ${parallax.currentOffset()}');

    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // velocity.negate();
    // // flipVertically();
    // print('COLLISION COIN');
    // FlameAudio.play('coin.mp3');
    if (other is Player) {
      coinSound.start();
      GetIt.instance<GameController>().coinsCollected.value += 10;
      add(RemoveEffect(delay: 0.1));
    }
  }
}
