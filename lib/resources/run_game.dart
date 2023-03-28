import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:get_it/get_it.dart';
import 'package:jumpy/export.dart';

class RunGame extends FlameGame
    with HasDraggables, HasCollisionDetection, TapDetector {
  ParallaxComponent? _parallaxComponent;
  Player? _player;
  World? _world;
  CameraComponent? _cameraComponent;
  CutterManager? _cutterManager;
  CoinManager? _coinManager;

  double height;

  RunGame({required this.height});

  @override
  bool get debugMode => false;

  @override
  void onTap() {
    GameController gameController = GetIt.instance<GameController>();
    if (gameController.gameStatus.value == GameStatus.pause) {
      gameController.gameStatus.value = GameStatus.start;
    } else if (gameController.gameStatus.value == GameStatus.start) {
      gameController.isJumping = true;
    }

    super.onTap();
  }

  loadWorld() async {
    _world = World()..addToParent(this);

    _cameraComponent = CameraComponent(
      world: _world!,
      //GetIt.instance<GameController>()
    );

    final skyLayer = await loadParallaxLayer(
      ParallaxImageData("sky.png"),
      fill: LayerFill.width,
    );
    final mountainLayer = await loadParallaxLayer(
      ParallaxImageData("mountains.png"),
      velocityMultiplier: Vector2(1.8, 0),
      fill: LayerFill.width,
    );
    final hillsLayer = await loadParallaxLayer(
      ParallaxImageData("hills.png"),
      velocityMultiplier: Vector2(2.6, 0),
      fill: LayerFill.width,
    );

    final treesLayer = await loadParallaxLayer(
      ParallaxImageData("trees.png"),
      velocityMultiplier: Vector2(3.8, 0),
      fill: LayerFill.width,
    );
    final grassLayer = await loadParallaxLayer(
      ParallaxImageData("grass.png"),
      velocityMultiplier: Vector2(4.0, 0),
      fill: LayerFill.width,
    );
    final landLayer = await loadParallaxLayer(
      ParallaxImageData("land.png"),
      velocityMultiplier: Vector2(4.6, 0),
      fill: LayerFill.width,
    );

    final cloudsLayer = await loadParallaxLayer(
      ParallaxImageData(
        'clouds.png',
      ),
      velocityMultiplier: Vector2(0.3, 0),
    );
    final Parallax parallax = Parallax(
      [
        skyLayer,
        cloudsLayer,
        mountainLayer,
        hillsLayer,
        treesLayer,
        grassLayer,
        landLayer,
      ],
      size: Vector2(100.h, 100.w),
      // baseVelocity: Vector2(20, 0),
    );
    _parallaxComponent = ParallaxComponent(parallax: parallax)
      ..anchor = Anchor.center;
    _player = Player(parallax);

    add(_cameraComponent!);
    _cutterManager = CutterManager(parallax, _world!);
    _coinManager = CoinManager(parallax, _world!);
    _world?.add(_parallaxComponent!);
    _world?.add(_player!);
    _world?.add(_cutterManager!);
    _world?.add(_coinManager!);
  }

  resetWorld() {
    _world?.remove(_parallaxComponent!);
    _world?.remove(_player!);
    _world?.remove(_cutterManager!);
    _world?.remove(_coinManager!);
    remove(_cameraComponent!);
    remove(_world!);
  }

  @override
  Future<void>? onLoad() async {
    Flame.device
      ..setLandscape()
      ..fullScreen();
    await FlameAudio.audioCache.load('coin.mp3');
    loadWorld();
    GetIt.instance<GameController>().gameStatus.addListener(() {
      if (GetIt.instance<GameController>().gameStatus.value ==
          GameStatus.restart) {
        resetWorld();
        loadWorld();
        GetIt.instance<GameController>().gameStatus.value = GameStatus.start;
      }
    });
    return super.onLoad();
  }
}
