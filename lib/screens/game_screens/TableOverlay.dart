import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/sprite_batch.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'dart:ui';

import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class TableOverlay {
  PositionComponent _table;
  PositionComponent _speedText;
  PositionComponent _rangeText;
  PositionComponent _coin;
  double x, y;
  TableOverlay(this.x, this.y) {
    _table = SpriteComponent.fromSprite(0, 0, Sprite('table.png'));
    final sprShe = SpriteSheet(
        imageName: 'coin.png',
        textureWidth: 32,
        textureHeight: 32,
        columns: 4,
        rows: 1);
    _coin = SpriteComponent.fromSprite(0, 0, sprShe.getSprite(0, 0));
    _speedText = SpriteComponent.fromSprite(0, 0, Sprite('speed.png'));
    _rangeText = SpriteComponent.fromSprite(0, 0, Sprite('range.png'));
  }
  void onTapDown(TapDownDetails detail, Player player) {
    if (_speedText.toRect().contains(detail.globalPosition)) {
      screenManager.setSpeedfactor(1.2, false);
      _speedText = SpriteComponent.fromSprite(0, 0, Sprite('speedout.png'));
      resize();
    }
    if (_rangeText.toRect().contains(detail.globalPosition)) {
      player.bulletLifetimeFctr += 1;
    }
  }

  void render(Canvas canvas) {
    canvas.save();
    _table.render(canvas);
    canvas.restore();
    // canvas.save();
    // _coin.render(canvas);
    // canvas.restore();
    canvas.save();
    _speedText.render(canvas);
    canvas.restore();
    canvas.save();
    _rangeText.render(canvas);
    canvas.restore();
  }

  void resize() {
    _table.x = x - screenSize.width * 0.18;
    _table.y = y - screenSize.height * 0.3;
    _table.width = screenSize.width * 0.18;
    _table.height = screenSize.height * 0.3;

    // _coin.x = _table.x + _table.width * 0.7;
    // _coin.y = _table.y + _table.height * 0.2;
    // _coin.width = _table.width * 0.2;
    // _coin.height = _table.height * 0.2;

    _speedText.x = _table.x + _table.width * 0.1;
    _speedText.y = _table.y + _table.height * 0.1;
    _speedText.width = _table.width * 0.8;
    _speedText.height = _table.height * 0.3;

    _rangeText.x = _table.x + _table.width * 0.1;
    _rangeText.y = _table.y + _table.height * 0.6;
    _rangeText.width = _table.width * 0.8;
    _rangeText.height = _table.height * 0.3;
  }

  void update(double t) {
    // TODO: implement update
  }

  bool contains(Offset position) {
    return _table.toRect().contains(position);
  }
}
