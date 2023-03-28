import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/audio_pool.dart';
import 'package:get_it/get_it.dart';
import 'package:jumpy/export.dart';
import 'package:uuid/uuid.dart';

class CoinManager extends Component {
  CoinManager(this.parallax, this.world);
  final Parallax parallax;
  final World world;
  bool isAdded = false;
  late Map<String, CoinSpriteComponent> lastCoinSpriteComponents = {};
  late AudioPool coinSound;
  @override
  Future<void>? onLoad() {
    String coinId = const Uuid().v1();
    lastCoinSpriteComponents[coinId] = CoinSpriteComponent(
      parallax,
      world,
      coinId: coinId,
      onRemoved: ((id) {
        lastCoinSpriteComponents.remove(id);
      }),
    );
    world.addAll(lastCoinSpriteComponents.values.toList());

    return super.onLoad();
  }

  @override
  void update(double dt) {
    GameAction action = GetIt.instance<GameController>().action;

    int noOfCoins = Random().nextInt(4) + 1;
    if (lastCoinSpriteComponents.isEmpty ||
        (lastCoinSpriteComponents.values.toList().last.position.x <= -300 &&
            lastCoinSpriteComponents.values.toList().last.topLeftPosition.x <=
                -300)) {
      if (lastCoinSpriteComponents.isNotEmpty) {
        world.removeAll(lastCoinSpriteComponents.values.toList());
        lastCoinSpriteComponents.clear();
      }
      // world.remove(lastCutterSpriteCOmponent);
      for (int i = 0; i <= noOfCoins; i++) {
        // lastCoinSpriteComponents.add(CoinSpriteComponent(parallax, world));
        String coinId = const Uuid().v1();
        lastCoinSpriteComponents[coinId] = CoinSpriteComponent(
          parallax,
          world,
          coinId: coinId,
          onRemoved: ((id) {
            lastCoinSpriteComponents.remove(id);
          }),
        );
      }
      world.addAll(lastCoinSpriteComponents.values.toList());
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
