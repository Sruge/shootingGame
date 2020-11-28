import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/friends/DealerBordCoin.dart';
import 'package:shootinggame/friends/DealerItem.dart';
import 'package:shootinggame/friends/DealerItemType.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class DealerBoard {
  PositionComponent table;

  Random _random;
  List<DealerItem> _dealerItems;
  List<DealerBordCoin> _dealerCoins;
  DealerBoard(this._dealerItems) {
    _dealerCoins = [];
    _dealerItems.forEach((item) {
      DealerBordCoin coin = DealerBordCoin(item.price);
      _dealerCoins.add(coin);
    });

    table = SpriteComponent.fromSprite(0, 0, Sprite('table.png'));
  }

  void onTapDown(TapDownDetails detail, Player player) {
    _dealerItems.forEach((element) {
      element.onTapDown(detail, player);
    });
  }

  void render(Canvas canvas) {
    canvas.save();
    table.render(canvas);
    canvas.restore();
    _dealerItems.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
    _dealerCoins.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
  }

  void resize(x, y) {
    table.x = x - screenSize.width * 0.18;
    table.y = y - screenSize.height * 0.3;
    table.width = screenSize.width * 0.25;
    table.height =
        screenSize.height * 0.1 + _dealerItems.length * screenSize.height * 0.1;

    for (int i = 0; i < _dealerItems.length; i++) {
      _dealerItems[i].resize(
          table.x + table.width * 0.1,
          table.y +
              screenSize.height * 0.03 * (i + 1) +
              i * screenSize.height * 0.1,
          table.width * 0.5,
          screenSize.height * 0.1);
    }

    for (int i = 0; i < _dealerCoins.length; i++) {
      _dealerCoins[i].resize(
          table.x + table.width * 0.7,
          table.y +
              screenSize.height * 0.03 * (i + 1) +
              i * screenSize.height * 0.1,
          Size(table.width * 0.2, screenSize.height * 0.1));
    }
  }
}
