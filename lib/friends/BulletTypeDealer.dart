import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/friends/DealerItemType.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'DealerBord.dart';
import 'DealerItem.dart';
import 'Friend.dart';

class BulletTypeDealer extends Friend {
  WalkingEntity entity;
  String aniPath;
  DealerBoard _dealerBoard;
  double _timer;
  double _lifetime;
  double _switchDirTime;
  double _direction;
  double _dyingtime;
  List<DealerItem> _items;
  bool _renderBoard;

  BulletTypeDealer() : super() {
    _items = [
      DealerItem(DealerItemType.BulletType2, 5),
      DealerItem(DealerItemType.BulletType3, 10)
    ];

    _dealerBoard = DealerBoard(_items);
    _renderBoard = false;
    _timer = 0;
    _lifetime = 15;
    _switchDirTime = 3;
    _direction = 1;
    _dyingtime = 0.1;
    enemySpeedFactor = 0.07;

    entity = WalkingEntity(
        'dealer3', 32, 48, Size(baseAnimationWidth, baseAnimationHeight));
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
    _timer += t;
    if (_timer > _switchDirTime) {
      _direction = -_direction;
      _switchDirTime += 3;
    }

    if (leftOrDown < 1) {
      enemySpeedX = enemySpeedFactor * _direction;
      enemySpeedY = 0;
    } else {
      enemySpeedY = enemySpeedFactor * _direction;
      enemySpeedX = 0;
    }
    if (enemySpeedX < 0) {
      flipRender = false;
    } else if (enemySpeedX > 0) {
      flipRender = true;
    }

    x = x +
        t * enemySpeedX * screenSize.width -
        t * bgSpeed[0] * screenSize.width;
    y = y +
        t * enemySpeedY * screenSize.width -
        t * bgSpeed[1] * screenSize.width;

    entity.update(t, [enemySpeedX, enemySpeedY]);
    if (_timer > _lifetime) {
      if (state == EntityState.Dying) {
        if (_timer > _lifetime + _dyingtime) die();
      } else {
        state = EntityState.Dying;
        _renderBoard = false;
        enemySpeedFactor = 0.7;
      }
    }
  }

  void onTapDown(TapDownDetails detail, Player player) {
    if (_renderBoard) {
      if (_dealerBoard.table.toRect().contains(detail.globalPosition)) {
        player.move = false;
        _dealerBoard.onTapDown(detail, player);
      } else {
        state = EntityState.Dying;
        _lifetime = _timer + 4;
        _renderBoard = false;
        enemySpeedFactor = 0.5;
      }
    } else if (entity.toRect().contains(detail.globalPosition) &&
        player.toRect().overlaps(entity.toRect())) {
      _renderBoard = true;
      enemySpeedFactor = 0;
      _dealerBoard.resize(detail.globalPosition.dx, detail.globalPosition.dy);

      _lifetime += 3;
    }
  }
}
