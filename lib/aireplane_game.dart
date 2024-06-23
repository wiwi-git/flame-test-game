// import 'dart:async' as ASYNC;

import 'dart:async';
import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame_tutorial_game/airplane_game_bg.dart';
import 'package:flame_tutorial_game/enemy_plane.dart';
import 'package:flame_tutorial_game/player_plane.dart';

class AirplaneGame extends FlameGame with HasCollisionDetection {
  late PlayerPlane _player;
  late Timer? _enemyTimer;
  late Timer? _enemyTimer2;
  // int currentEnemyCount = 0;
  // final int maxEnemyCount = 10;

  // 게임 인스턴스가 생성될때 실행하는 함수, 대부분 여기에 내용을 배치한다.
  @override
  Future<void> onLoad() async {
    final AirplaneGameBg bg = AirplaneGameBg();
    await add(bg);
    _player = PlayerPlane(
      position: Vector2(size.x / 2 - 30, size.y - 100),
      hitAction: hitAction,
    );
    await add(_player);
    overlays.add("leftRightButton");

    // 타이머 한개는 1초마다, 한개는 1.5초마다 적 비행기 생성한다.
    // 타이머 시간은 임의로 수정하면 된다.
    _enemyTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      addEnemy();
    });
    _enemyTimer2 = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      addEnemy();
    });

    super.onLoad();
  }

  void addEnemy() {
    // if (currentEnemyCount >= maxEnemyCount) return;
    final enemy = createEnemy();
    add(enemy);
    // currentEnemyCount += 1;
  }

  EnemyPlane createEnemy() {
    // x축의 위치를 랜덤하게 만들어준다.
    // y축의 위치는 임의로 30으로 고정한다.
    int randomDx = Random().nextInt(13) + 1;
    int randomSpeed = Random().nextInt(15) + 1;

    return EnemyPlane(
      position: Vector2(randomDx * 30, 30),
      speed: randomSpeed,
    );
  }

  // 업데이트 되는 매 프레임마다 실행되는 로직
  @override
  void update(double dt) async {
    super.update(dt);
  }

  // 인스턴스가 해제될 떄 실행되는 로직
  @override
  void onRemove() {
    super.onRemove();
  }

  void hitAction() {}

  void flyLeft() {
    _player.position = Vector2(_player.position.x - 10, _player.position.y);
  }

  void flyRight() {
    _player.position = Vector2(_player.position.x + 10, _player.position.y);
  }
}
