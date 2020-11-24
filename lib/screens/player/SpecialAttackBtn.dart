import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flame/spritesheet.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'dart:ui';

import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/player/AttackType.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class SpecialAttackBtn extends BaseWidget {
  PositionComponent _button;
  AnimationComponent _buttonActive;
  AttackType type;
  bool isActive;
  double x, y;
  int count;
  SpecialAttackBtn(this.type, this.count, this.x, this.y) {
    isActive = false;
    String imgUrl;
    switch (type) {
      case AttackType.Normal:
        imgUrl = 'empty';
        break;
      case AttackType.Fire:
        imgUrl = 'fire';
        break;
      case AttackType.Freeze:
        imgUrl = 'freeze';
        break;
      case AttackType.Night:
        imgUrl = 'night';
        break;
      case AttackType.Heal:
        imgUrl = 'green';
        break;
      default:
        imgUrl = 'empty';
        type = AttackType.Normal;
    }
    _button =
        SpriteComponent.fromSprite(48, 48, Sprite('${imgUrl}inactive.png'));
    if (type != AttackType.Normal) {
      final sprShe = SpriteSheet(
          imageName: '${imgUrl}active.png',
          textureWidth: 128,
          textureHeight: 128,
          columns: 4,
          rows: 1);
      final animation = sprShe.createAnimation(0, stepTime: 0.2);
      _buttonActive = AnimationComponent(48, 48, animation);
    }
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (type != AttackType.Normal &&
        _button.toRect().contains(detail.globalPosition)) {
      isActive = !isActive;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    if (isActive)
      _buttonActive.render(canvas);
    else
      _button.render(canvas);
    canvas.restore();
  }

  @override
  void resize() {
    _button.resize(Size(screenSize.width * 0.03, screenSize.width * 0.03));
    _button.x = x;
    _button.y = y + screenSize.height * 0.02;
    if (type != AttackType.Normal) {
      _buttonActive
          .resize(Size(screenSize.width * 0.03, screenSize.width * 0.03));
      _buttonActive.x = x;
      _buttonActive.y = y + screenSize.height * 0.02;
    }
  }

  @override
  void update(double t) {
    if (isActive) {
      _buttonActive.update(t);
      _buttonActive.animation.update(t);
      _buttonActive.x = x;
      _buttonActive.y = y + screenSize.height * 0.02;
    } else {
      _button.update(t);
    }
  }

  Rect toRect() {
    if (isActive)
      return _buttonActive.toRect();
    else
      return _button.toRect();
  }

  AttackType getAttackType() {
    return type;
  }
}
