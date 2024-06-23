import 'package:flame/game.dart';
import 'package:flame_tutorial_game/aireplane_game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: GamePage(),
  ));
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Airplane game'),
      ),
      body: Center(
        child: GameWidget(
          game: AirplaneGame(),
          overlayBuilderMap: {
            'leftRightButton': (BuildContext context, AirplaneGame game) {
              return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // 왼쪽으로 이동
                            game.flyLeft();
                          },
                          child: const Text("<")),
                      ElevatedButton(
                          onPressed: () {
                            // 오른쪽으로 이동
                            game.flyRight();
                          },
                          child: const Text(">")),
                    ],
                  ),
                ),
              );
            },
          },
        ),
      ),
    );
  }
}
