import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'dart:ui';

import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/player/SpecialAttackBtn.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

class ButtonBar extends BaseWidget {
  List<SpecialAttackBtn> _buttons;
  double _distanceButton;
  double firstBtnX;
  double y;
  ButtonBar() {
    _distanceButton = screenSize.width * 0.03;
    _buttons = List.empty(growable: true);
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void render(Canvas canvas) {
    _buttons.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
  }

  @override
  void resize() {
    y = screenSize.height - screenSize.width * 0.03 - screenSize.width * 0.05;
    _buttons.forEach((element) {
      element.resize();
    });
  }

  @override
  void update(double t) {
    firstBtnX =
        (screenSize.width - (screenSize.width * 0.07) * _buttons.length) / 2;
    double pushDistance = 0;

    _buttons.forEach((element) {
      element.update(t);
      element.x = firstBtnX + pushDistance;
      element.y = y;
      pushDistance += screenSize.width * 0.07;
    });
  }

  void add(EffectType _type) {
    _buttons.add(SpecialAttackBtn(_type, 0, 0));
  }
}
