import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jumpy/export.dart';

class CutterSpriteComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef {
  CutterSpriteComponent(this.parallax, this.world,
      {this.initPosition, this.midWayCallback})
      : velocity = Vector2.zero(),
        super(size: Vector2(23.w, 18.w));
  final Parallax parallax;
  final Vector2? initPosition;
  final World world;
  final Vector2 velocity;
  final double runSpeed = 200.0;
  final ValueChanged? midWayCallback;
  late AudioPool collisionSound;

  @override
  Future<void>? onLoad() async {
    collisionSound = await AudioPool.create('audio/hit.mp3', maxPlayers: 1);
    priority = 10;
    x = 35.h;
    y = 18.w;
    final sprites =
        [1, 2, 3, 4, 5, 6].map((i) => Sprite.load('rotating_saw_0$i.png'));
    final spriteAnimation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.08,
    );
    animation = spriteAnimation;

    // final hitboxPaint = BasicPalette.white.paint()
    //   ..style = PaintingStyle.stroke;
    // add(
    //   PolygonHitbox.relative(
    //     [
    //       Vector2(0.0, -1.0),
    //       Vector2(-1.0, -0.1),
    //       Vector2(-0.2, 0.4),
    //       Vector2(0.2, 0.4),
    //       Vector2(1.0, -0.1),
    //     ],
    //     parentSize: size,
    //   )
    //     ..paint = hitboxPaint
    //     ..renderShape = true,
    // );
    add(CircleHitbox());
    return super.onLoad();
  }

  @override
  void update(double dt) {
    GameController gameController = GetIt.instance<GameController>();
    // GameAction action = gameController.action;
    // bool isJumping = gameController.isJumping;
    x += parallax.currentOffset().x;
    // if (action.isMovingRight) {
    //   x -= parallax.currentOffset().x + 4;
    // } else if (action.isMovingLeft) {
    //   x -= parallax.currentOffset().x + 4;
    // }
    if (gameController.gameStatus.value == GameStatus.start) {
      x -= parallax.currentOffset().x + 4;
    }

    if (x <= 240 && midWayCallback != null) {
      midWayCallback!(true);
    }
    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // velocity.negate();
    // flipVertically();
    collisionSound.start();
    if (other is Player) {
      GetIt.instance<GameController>().setGameState(GameStatus.over);
      GetIt.instance<GameController>().currentGameRef = gameRef;
      gameRef.paused = true;
      PreferenceHelper.setHighscore = GetIt.instance<GameController>().score;
    }
    // print('COLLISION');
  }
}
