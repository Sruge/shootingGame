import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/bullets/Bullet.dart';
import 'package:shootinggame/bullets/FireRingBullet.dart';
import 'package:shootinggame/bullets/FreezeBullet.dart';
import 'package:shootinggame/bullets/HealBullet.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/entities/WalkingEntity.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'DealerBord.dart';
import 'Friend.dart';
import 'FriendType.dart';

class Firetree extends Friend {
  String aniPath;
  DealerBord _dealerBord;
  double _timer;
  double _lifetime;
  double _dyingtime;
  AnimationComponent _tree;
  double _attackTime;
  List<SpecialBullet> bullets;
  double _x, _y, _power;
  Firetree(this._x, this._y, this._power) : super() {
    attackRange = 130;
    attackInterval = 3;
    _timer = 0;
    _lifetime = 30;
    _dyingtime = 2;
    _attackTime = 5;
    bullets = [];

    _dealerBord = DealerBord(true);
    enemySpeedFactor = 0;

    final sprShe = SpriteSheet(
        imageName: 'firetree.png',
        textureWidth: 128,
        textureHeight: 128,
        columns: 4,
        rows: 1);
    final animation = sprShe.createAnimation(0, stepTime: 0.2);
    _tree = AnimationComponent(
        baseAnimationWidth * 1.5, baseAnimationHeight * 1.5, animation);
  }

  void update(double t, List<double> bgSpeed) {
    _timer += t;

    _x = _x - t * bgSpeed[0] * screenSize.width;
    _y = _y - t * bgSpeed[1] * screenSize.width;
    _tree.animation.update(t);
    if (_timer > _attackTime) {
      List<double> coords = getAttackingCoordinates(_tree.x, _tree.y);
      FireRingBullet bullet = FireRingBullet(
          coords[0], coords[1], coords[2], coords[3], _power, _power, _power);
      bullet.resize();
      bullets.add(bullet);
      _attackTime = _timer + 12;
    }
    if (_timer > _lifetime) {
      if (state == EntityState.Dying) {
        if (_timer > _lifetime + _dyingtime) die();
      } else {
        _attackTime = 0.2;
        state = EntityState.Dying;
      }
    }
  }

  void resize() {
    _tree.x = _x;
    _tree.y = _y;
  }

  void render(Canvas canvas) {
    _tree.x = _x;
    _tree.y = _y;
    canvas.save();
    _tree.render(canvas);
    canvas.restore();
  }

  @override
  EffectType getEffect() {
    return EffectType.Deal;
  }

  bool contains(Offset offset) {
    return _tree.toRect().contains(offset);
  }

  bool overlaps(Rect rect) {
    return _tree.toRect().overlaps(rect);
  }

  @override
  void trigger() {
    screenManager.showDeal(x, y, _dealerBord);
  }
}
