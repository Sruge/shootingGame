import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/bullets/HealBullet.dart';
import 'package:shootinggame/bullets/SpecialBullet.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/entities/EntityState.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'Friend.dart';

class Tree extends Friend {
  String aniPath;
  double _timer;
  double _lifetime;
  double _dyingtime;
  AnimationComponent _tree;
  double _attackTime;
  List<SpecialBullet> bullets;
  double _x, _y, _power;
  Tree(this._x, this._y, this._power) : super() {
    attackRange = 130;
    attackInterval = 3;
    _timer = 0;
    _lifetime = 20;
    _dyingtime = 2;
    _attackTime = 5;
    bullets = [];

    enemySpeedFactor = 0;

    final sprShe = SpriteSheet(
        imageName: 'tree.png',
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
      List<double> coords =
          getAttackingCoordinates(_tree.x, _tree.y, _tree.width, _tree.height);
      HealBullet bullet =
          HealBullet(coords[0], coords[1], coords[2], coords[3], _power * 1.5);
      bullet.resize();
      bullets.add(bullet);
      _attackTime = _timer + _attackTime;
    }
    if (_timer > _lifetime) {
      if (state == EntityState.Dying) {
        if (_timer > _lifetime + _dyingtime) die();
      } else {
        _attackTime = 0.5;
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

  bool contains(Offset offset) {
    return _tree.toRect().contains(offset);
  }

  bool overlaps(Rect rect) {
    return _tree.toRect().overlaps(rect);
  }
}
