import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';

class DealerBordCoin {
  int _amount;
  PositionComponent _coin;
  double _x, _y;
  DealerBordCoin(this._amount) {
    _coin = SpriteComponent.fromSprite(0, 0, Sprite('buy$_amount.png'));
    _coin.x = _x;
    _coin.y = _y;
  }

  void render(Canvas canvas) {
    canvas.save();
    _coin.render(canvas);
    canvas.restore();
  }

  void resize(double x, double y, Size size) {
    _coin.width = size.width;
    _coin.height = size.height;
    _coin.x = x;
    _coin.y = y;
  }
}
