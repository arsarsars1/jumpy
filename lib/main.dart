import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:jumpy/export.dart';

void main() {
  setUp();
  runApp(const MyGame());
}

setUp() {
  GetIt getIt = GetIt.instance;
  getIt.registerLazySingleton<GameController>(() => GameController());
}

class MyGame extends StatefulWidget {
  const MyGame({super.key});

  @override
  State<MyGame> createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  @override
  void initState() {
    PreferenceHelper.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      pixelDensity: false,
      designUISize: const Size(800, 300),
      builder: (ctx, orientation, deviceType) => MaterialApp(
        home: Stack(
          children: [
            GameWidget(
              game: RunGame(height: 800),
            ),
            // Positioned(
            //   left: 0,
            //   bottom: 4.w,
            //   child: const GamePad(),
            // ),
            Positioned(
              child: ValueListenableBuilder(
                valueListenable:
                    GetIt.instance<GameController>().coinsCollected,
                builder: ((context, value, child) {
                  return Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(left: 2.w, top: 2.w),
                      child: Text(
                        "Score: $value",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Bungee",
                          fontSize: 26,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: GetIt.instance<GameController>().gameStatus,
              builder: (context, gameStatus, __) {
                if (gameStatus == GameStatus.over) {
                  return Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: double.infinity,
                        ),
                        const Text(
                          "Game Over",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: "BungeeInline",
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          "Score: ${GetIt.instance<GameController>().coinsCollected.value}",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Bungee",
                            fontSize: 24,
                          ),
                        ), //
                        TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black87,
                            backgroundColor: Colors.white38,
                            // padding: const EdgeInsets.all(16.0),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontFamily: "Bungee",
                            ),
                          ),
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            GetIt.instance<GameController>()
                                .coinsCollected
                                .value = 0;
                            GetIt.instance<GameController>()
                                .setGameState(GameStatus.restart);

                            GetIt.instance<GameController>()
                                .currentGameRef
                                ?.resumeEngine();
                          },
                          label: const Text('Play Again'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
