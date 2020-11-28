import 'dart:math';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/friends/DealerItemType.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'DealerBord.dart';
import 'DealerItem.dart';
import 'Friend.dart';

class StandardDealer extends Friend {
  WalkingEntity entity;
  String aniPath;
  DealerBoard _dealerBoard;
  List<DealerItem> _items;
  bool _renderBoard;

  StandardDealer() : super() {
    _items = [
      DealerItem(DealerItemType.Health, 1),
      DealerItem(DealerItemType.Bullets, 1)
    ];

    _dealerBoard = DealerBoard(_items);
    _renderBoard = false;

    entity = WalkingEntity(
        'dealer2', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
  }

  void render(Canvas canvas) {
    super.render(canvas);
    if (_renderBoard) {
      canvas.save();
      _dealerBoard.render(canvas);
      canvas.restore();
    }
  }

  void update(double t, List<double> bgSpeed) {
    x = x - t * bgSpeed[0] * screenSize.width;
    y = y - t * bgSpeed[1] * screenSize.width;

    entity.update(t, [enemySpeedX, enemySpeedY]);
  }

  void onTapDown(TapDownDetails detail, Player player) {
    if (_renderBoard) {
      if (_dealerBoard.table.toRect().contains(detail.globalPosition)) {
        player.move = false;
        _dealerBoard.onTapDown(detail, player);
      } else {
        _renderBoard = false;
      }
    } else if (entity.toRect().contains(detail.globalPosition) &&
        player.toRect().overlaps(entity.toRect())) {
      _renderBoard = true;
      _dealerBoard.resize(detail.globalPosition.dx, detail.globalPosition.dy);
    }
  }
}
