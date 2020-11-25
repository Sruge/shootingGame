import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/gestures/tap.dart';

import 'SizeHolder.dart';

class DynamicBackground {
  double _speedX;
  double _speedY;

  SpriteComponent _bg;
  double x;
  double y;
  double _destinationX;
  double _destinationY;

  DynamicBackground(this._speedX, this._speedY, String imgSrc) {
    _bg = SpriteComponent.fromSprite(0, 0, Sprite(imgSrc));

    x = 0;
    y = 0;

    _destinationX = x;
    _destinationY = y;
  }

  void onTapDown(TapDownDetails detail, List<double> speed) {
    setSpeed(speed);
    _destinationX = x - (detail.globalPosition.dx - screenSize.width / 2);
    _destinationY = y - (detail.globalPosition.dy - screenSize.height / 2);
  }

  void render(Canvas canvas) {
    canvas.save();
    _bg.x = x + screenSize.width * 3;
    _bg.y = y;
    _bg.render(canvas);
    canvas.restore();

    canvas.save();
    _bg.x = x;
    _bg.y = y;
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
      x -= t * _speedX * screenSize.width;
      y -= t * _speedY * screenSize.width;
    }
  }

  bool hasReachedDestinationOrBorder() {
    if ((_speedX > 0 && x < _destinationX) ||
        (_speedX < 0 && x > _destinationX)) {
      return true;
    } else if ((_speedX < 0) &&
            x > screenSize.width / 2 - screenSize.width * 0.03 ||
        (_speedX > 0) &&
            x <
                -screenSize.width * 5 -
                    screenSize.width / 2 +
                    screenSize.width * 0.03) {
      return true;
    }
    if ((_speedY > 0 && y < _destinationY) ||
        (_speedY < 0 && y > _destinationY)) {
      return true;
    } else if (_speedY < 0 &&
            y > screenSize.height / 2 - screenSize.height * 0.05 ||
        _speedY > 0 &&
            y <
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
