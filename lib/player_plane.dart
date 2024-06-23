// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tutorial_game/enemy_plane.dart';
import 'package:flutter/material.dart';

class PlayerPlane extends SpriteComponent with HasGameRef, CollisionCallbacks {
  static const double playerSize = 60.0;
  final Function hitAction;
  late ShapeHitbox hitbox;

  PlayerPlane({
    required position,
    required this.hitAction,
  }) : super(
          size: Vector2.all(playerSize),
          position: position,
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    sprite = await gameRef.loadSprite('player.png');
    position = position;

    final defaultPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke;
    hitbox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitbox);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is ScreenHitbox) {
      // 그대로 x값 0에 고정
      if (position.x < size.x) {
        position = Vector2(0, position.y);
        // 그게 아니면? 겹치지 않는 맨 끝 위치에 고정
      } else {
        position = Vector2(game.size.x - size.x, position.y);
      }
    } else if (other is EnemyPlane) {
      hitAction();
    }
  }
}
