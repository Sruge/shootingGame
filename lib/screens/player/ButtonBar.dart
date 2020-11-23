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
  PositionComponent _buttonBar;

  PositionComponent _topBar;
  double _distanceButton;
  double firstBtnX;
  double y;
  ButtonBar() {
    _distanceButton = screenSize.width * 0.03;
    _buttons = List.empty(growable: true);
    _buttonBar = SpriteComponent.fromSprite(0, 0, Sprite('buttonBar.png'));
    _topBar = SpriteComponent.fromSprite(0, 0, Sprite('buttonBar.png'));
    _topBar.renderFlipY = true;
  }

  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    // TODO: implement onTapDown
  }

  @override
  void render(Canvas canvas) {
    canvas.save();
    _buttonBar.render(canvas);
    canvas.restore();
    canvas.save();
    _topBar.render(canvas);
    canvas.restore();
    _buttons.forEach((element) {
      canvas.save();
      element.render(canvas);
      canvas.restore();
    });
  }

  @override
  void resize() {
    _buttonBar.width = screenSize.width * 0.25;
    _buttonBar.height = screenSize.height * 0.10;
    _buttonBar.x = screenSize.width * 0.375;
    _buttonBar.y = screenSize.height * 0.90;
    y = screenSize.height - screenSize.width * 0.03 - screenSize.width * 0.05;
    _buttons.forEach((element) {
      element.resize();
    });
    _topBar.width = screenSize.width * 0.50;
    _topBar.height = screenSize.height * 0.10;
    _topBar.x = screenSize.width * 0.25;
    _topBar.y = 0;
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
