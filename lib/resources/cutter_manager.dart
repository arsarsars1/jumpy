import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:get_it/get_it.dart';
import 'package:jumpy/export.dart';

class CutterManager extends Component {
  CutterManager(this.parallax, this.world);
  final Parallax parallax;
  final World world;
  bool isAdded = false;
  late CutterSpriteComponent lastCutterSpriteCOmponent;
  @override
  Future<void>? onLoad() {
    lastCutterSpriteCOmponent = CutterSpriteComponent(parallax, world);
    world.add(lastCutterSpriteCOmponent);
    return super.onLoad();
  }

  @override
  void update(double dt) {
    GameAction action = GetIt.instance<GameController>().action;
    int rand = Random().nextInt(6);

    if (lastCutterSpriteCOmponent.position.x <= -200 &&
        lastCutterSpriteCOmponent.topLeftPosition.x <= -300) {
      world.remove(lastCutterSpriteCOmponent);
      lastCutterSpriteCOmponent = CutterSpriteComponent(parallax, world);
      world.add(lastCutterSpriteCOmponent);
    }
    // if (parallax.currentOffset().x <= 0.15 &&
    //     !isAdded &&
    //     action.isMovingRight) {
    //   isAdded = true;
    //   world.add(CutterSpriteComponent(parallax, world));
    // }
    super.update(dt);
  }
}
