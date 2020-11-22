import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class WalkingEntity {
  AnimationComponent _walkingUp;
  AnimationComponent _walkingDown;
  AnimationComponent _walkingSide;
  AnimationComponent _activeEntity;
  double x, y;
  double speedX, speedY;
  int _txtWidth, _txtHeight;
  WalkingEntity(String imgUrl, this._txtWidth, this._txtHeight) {
    this.x = 0;
    this.y = 0;
    this.speedX = 0;
    this.speedY = 0;
    final spriteSheet = SpriteSheet(
        imageName: imgUrl,
        textureWidth: _txtWidth,
        textureHeight: _txtHeight,
        columns: 4,
        rows: 4);
    _walkingDown = AnimationComponent(
        0, 0, spriteSheet.createAnimation(0, stepTime: 0.15));
    _walkingSide = AnimationComponent(
        0, 0, spriteSheet.createAnimation(1, stepTime: 0.15));
    _walkingUp = AnimationComponent(
        0, 0, spriteSheet.createAnimation(3, stepTime: 0.15));
    _activeEntity = _walkingDown;
  }

  void resize() {
    _walkingDown.width = screenSize.width * 0.06;
    _walkingDown.height = screenSize.height * 0.14;
    _walkingDown.x = x;
    _walkingDown.y = y;

    _walkingSide.width = screenSize.width * 0.06;
    _walkingSide.height = screenSize.height * 0.14;
    _walkingSide.x = x;
    _walkingSide.y = y;

    _walkingUp.width = screenSize.width * 0.06;
    _walkingUp.height = screenSize.height * 0.14;
    _walkingUp.x = x;
    _walkingUp.y = y;
  }

  void render(Canvas canvas) {
    _activeEntity.x = x;
    _activeEntity.y = y;
    canvas.save();
    _activeEntity.render(canvas);
    canvas.restore();
  }

  void update(double t, List<double> speed) {
    speedX = speed[0];
    speedY = speed[1];
    if ((speedY * 0.7).abs() < speedX.abs()) {
      _activeEntity = _walkingSide;
      _walkingSide.update(t);
      if (speedX > 0)
        _walkingSide.renderFlipX = true;
      else
        _walkingSide.renderFlipX = false;
    } else if (speedY > 0) {
      _activeEntity = _walkingDown;
      _walkingDown.update(t);
    } else if (speedY < 0) {
      _activeEntity = _walkingUp;
      _walkingUp.update(t);
    }
  }

  Rect toRect() {
    return _activeEntity.toRect();
  }
}
