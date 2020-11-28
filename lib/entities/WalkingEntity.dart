import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';

class WalkingEntity {
  AnimationComponent _walkingUp;
  AnimationComponent _walkingDown;
  AnimationComponent _walkingSide;
  AnimationComponent _standingUp;
  AnimationComponent _standingDown;
  AnimationComponent _standingSide;
  AnimationComponent _activeEntity;
  AnimationComponent _overwrittenEntity;
  double x, y;
  double speedX, speedY;
  int _txtWidth, _txtHeight;
  Size size;
  int lastPos;
  bool _overwritten;

  WalkingEntity(String imgUrl, this._txtWidth, this._txtHeight, this.size) {
    this.x = 0;
    this.y = 0;
    this.speedX = 0;
    this.speedY = 0;
    this._overwritten = false;
    String standingImgUrl = '${imgUrl}standing.png';
    imgUrl = '${imgUrl}.png';
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

    final spriteSheetStanding = SpriteSheet(
        imageName: standingImgUrl,
        textureWidth: _txtWidth,
        textureHeight: _txtHeight,
        columns: 2,
        rows: 4);
    _standingDown = AnimationComponent(
        0, 0, spriteSheetStanding.createAnimation(0, stepTime: 0.15));
    _standingSide = AnimationComponent(
        0, 0, spriteSheetStanding.createAnimation(1, stepTime: 0.15));
    _standingUp = AnimationComponent(
        0, 0, spriteSheetStanding.createAnimation(3, stepTime: 0.15));

    _activeEntity = _walkingDown;
  }

  void resize() {
    _walkingDown.width = size.width;
    _walkingDown.height = size.height;
    _walkingDown.x = x;
    _walkingDown.y = y;

    _walkingSide.width = size.width;
    _walkingSide.height = size.height;
    _walkingSide.x = x;
    _walkingSide.y = y;

    _walkingUp.width = size.width;
    _walkingUp.height = size.height;
    _walkingUp.x = x;
    _walkingUp.y = y;

    _standingDown.width = size.width;
    _standingDown.height = size.height;
    _standingDown.x = x;
    _standingDown.y = y;

    _standingSide.width = size.width;
    _standingSide.height = size.height;
    _standingSide.x = x;
    _standingSide.y = y;

    _standingUp.width = size.width;
    _standingUp.height = size.height;
    _standingUp.x = x;
    _standingUp.y = y;
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
    if (!_overwritten) {
      if ((speedY * 0.7).abs() < speedX.abs()) {
        _activeEntity = _walkingSide;
        if (speedX > 0)
          _walkingSide.renderFlipX = true;
        else
          _walkingSide.renderFlipX = false;
      } else if (speedY > 0) {
        _activeEntity = _walkingDown;
      } else if (speedY < 0) {
        _activeEntity = _walkingUp;
      } else {
        if (_activeEntity == _walkingDown)
          _activeEntity = _standingDown;
        else if (_activeEntity == _walkingUp)
          _activeEntity = _standingUp;
        else if (_activeEntity == _walkingSide) {
          _activeEntity = _standingSide;
          _standingSide.renderFlipX = _walkingSide.renderFlipX;
        }
      }
    }

    _activeEntity.update(t);
  }

  Rect toRect() {
    return _activeEntity.toRect();
  }

  void overwriteActiveEntity(AnimationComponent ani) {
    if (!_overwritten) {
      _overwritten = true;
      _overwrittenEntity = _activeEntity;
      _activeEntity = ani;
    }
  }

  void reset() {
    _overwritten = false;
    _activeEntity = _overwrittenEntity;
    _overwrittenEntity = null;
  }
}
