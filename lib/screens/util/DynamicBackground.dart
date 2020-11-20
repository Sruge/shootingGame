import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/gestures/tap.dart';

import 'SizeHolder.dart';

class DynamicBackground {
  double _speedX;
  double _speedY;

  SpriteComponent _bg;
  double _x;
  double _y;
  double _destinationX;
  double _destinationY;

  DynamicBackground(this._speedX, this._speedY, String imgSrc) {
    _bg = SpriteComponent.fromSprite(0, 0, Sprite(imgSrc));

    _x = 0;
    _y = 0;

    _destinationX = _x;
    _destinationY = _y;
  }

  void onTapDown(TapDownDetails detail, List<double> speed) {
    setSpeed(speed);
    _destinationX = _x - (detail.globalPosition.dx - screenSize.width / 2);
    _destinationY = _y - (detail.globalPosition.dy - screenSize.height / 2);
  }

  void render(Canvas canvas) {
    canvas.save();
    _bg.x = _x + screenSize.width * 3;
    _bg.y = _y;
    _bg.render(canvas);
    canvas.restore();

    canvas.save();
    _bg.x = _x;
    _bg.y = _y;
    _bg.render(canvas);
    canvas.restore();
  }

  void resize() {
    _bg.width = screenSize.width * 3;
    _bg.height = screenSize.height * 3;
  }

  void update(double t, List<double> speed) {
    setSpeed(speed);
    if (hasReachedDestinationOrBorder()) {
      _speedX = 0;
      _speedY = 0;
    } else {
      _x -= t * _speedX * screenSize.width;
      _y -= t * _speedY * screenSize.width;
    }
  }

  bool hasReachedDestinationOrBorder() {
    if ((_speedX > 0 && _x < _destinationX) ||
        (_speedX < 0 && _x > _destinationX)) {
      return true;
    } else if ((_speedX < 0) &&
            _x > screenSize.width / 2 - screenSize.width * 0.03 ||
        (_speedX > 0) &&
            _x <
                -screenSize.width * 5 -
                    screenSize.width / 2 +
                    screenSize.width * 0.03) {
      return true;
    }
    if ((_speedY > 0 && _y < _destinationY) ||
        (_speedY < 0 && _y > _destinationY)) {
      return true;
    } else if (_speedY < 0 &&
            _y > screenSize.height / 2 - screenSize.height * 0.05 ||
        _speedY > 0 &&
            _y <
                -screenSize.height * 2 -
                    screenSize.height / 2 +
                    screenSize.height * 0.05) {
      return true;
    }
    return false;
  }

  void setSpeed(List<double> speed) {
    _speedX = speed[0];
    _speedY = speed[1];
  }
}
