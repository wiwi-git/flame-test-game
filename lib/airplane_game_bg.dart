import 'dart:async';

import 'package:flame/components.dart';

class AirplaneGameBg extends SpriteComponent with HasGameRef {
  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('background.png');
    size = Vector2(gameRef.size.x, gameRef.size.y);
  }
}
