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

class DealerBord {
  PositionComponent table;

  bool _atLeastOneSlotOpen;
  Random _random;
  List<DealerItem> _dealerItems;
  List<DealerBordCoin> _dealerCoins;
  DealerBord(this._atLeastOneSlotOpen) {
    _random = Random();
    int price1 = _random.nextInt(3) + 1;
    int price2 = _random.nextInt(3) + 1;
    List<DealerItemType> _possibleItemTypes = DealerItemType.values.toList();
    if (!_atLeastOneSlotOpen) {
      _possibleItemTypes.remove(DealerItemType.SpecialBullets);
    }
    DealerItemType _itemType1 =
        _possibleItemTypes[_random.nextInt(_possibleItemTypes.length)];
    DealerBordCoin _coin1 = DealerBordCoin(price1);
    _possibleItemTypes.remove(_itemType1);
    DealerItemType _itemType2 =
        _possibleItemTypes[_random.nextInt(_possibleItemTypes.length)];
    DealerBordCoin _coin2 = DealerBordCoin(price2);
    _dealerItems = [
      DealerItem(_itemType1, price1),
      DealerItem(_itemType2, price2)
    ];
    _dealerCoins = [_coin1, _coin2];
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
