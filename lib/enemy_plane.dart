import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tutorial_game/player_plane.dart';
import 'package:flutter/material.dart';
import 'dart:async' as ASYNC;

enum EnemyPlaneState { flying, hit }

class EnemyPlane extends SpriteComponent with HasGameRef, CollisionCallbacks {
  // 우리 플레이어 비행기랑 똑같이 60픽셀로
  static const double enemySize = 60.0;
  final int speed;

  EnemyPlane({
    required position,
    required this.speed,
  }) : super(
          size: Vector2.all(enemySize),
          position: position,
        );

  //초기 상태는 비행중으로
  var _state = EnemyPlaneState.flying;

  //getter를 써서 상태를 외부에서 변경 못하도록
  EnemyPlaneState get state => _state;

  late ShapeHitbox hitbox;
  late Sprite? _spirte;

  ASYNC.Timer? destroyTimer;

  @override
  void onLoad() async {
    super.onLoad();
    _spirte = await gameRef.loadSprite("enemy01.png");
    sprite = _spirte;
    position = position;

    // 플레이어 비행기랑 똑같이 빨간 선으로 히트박스 표시
    final Paint defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void update(double dt) {
    // y값(세로)을 변경해서 날아가도록 수정해보자
    // y값을 변경하며 매 프레임마다 아래로 날아가도록 로직을 구현하자
    // 외부에서 속도를 받아와서, flying(날고있는)상태면 계속 y값을 아래로 내리기
    if (_state == EnemyPlaneState.flying) {
      position = Vector2(position.x, position.y + speed);
      super.update(dt);
    }
  }

  @override
  void onCollision(Set<Vector2> points, PositionComponent other) {
    super.onCollision(points, other);
    if (other is ScreenHitbox) {
      // PlayerPlane때 한대로 비슷하게 구현하면 된다.
      if (position.x > game.size.x) {
        if (position.x < size.x) {
          position = Vector2(0, position.y);
          return;
        } else {
          position = Vector2(game.size.x - size.x, position.y);
          return;
        }
      }
      // removeFromParent는 컴포넌트 클래스의 내부함수로, 이 컴포넌트를 해제한다.
      // 나랑 안 부딛히고 바닥에 부딛히면 없애버리자.
      if (position.y + size.y > game.size.y) {
        removeFromParent();
      }
      // player랑 부딛히면 비행기를 멈추고 사라지게 하는 함수 추가
    } else if (other is PlayerPlane) {
      stopPlane();
    } else if (other is EnemyPlane) {
    } else {
      print('hit unknown');
      stopPlane();
    }
  }

  void stopPlane() {
    _state = EnemyPlaneState.hit;
    destroy();
    Future.delayed(const Duration(seconds: 1), (() => removeFromParent()));
    // Timer클래스는 다 사용하면 항상 cancel()로 해제하자
    destroyTimer?.cancel();
  }

  bool blink = false;

  // PlayerPlane과 충돌나면 깜빡거리는 점멸효과를 1초정도 준다.
  void destroy() async {
    // _spirte = await gameRef.loadSprite("enemy01.png");
    sprite = null;

    destroyTimer = ASYNC.Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        print('blink~ $blink');
        if (blink == true) {
          sprite = null;
          blink = false;
        } else {
          sprite = _spirte;
          blink = true;
        }
      },
    );
  }
}
