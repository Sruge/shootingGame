import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/painting.dart';
import 'dart:ui';

import 'package:shootinggame/screens/player/AttackType.dart';
import 'package:shootinggame/screens/player/SpecialAttackBtn.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'Player.dart';

class ButtonBar {
  List<SpecialAttackBtn> _buttons;
  PositionComponent _buttonBar;

  PositionComponent _topBar;
  double firstBtnX;
  double y;
  int activeButton;

  ButtonBar(int buttonCount) {
    _buttons = List.empty(growable: true);
    _buttonBar = SpriteComponent.fromSprite(0, 0, Sprite('buttonBar.png'));
    _topBar = SpriteComponent.fromSprite(0, 0, Sprite('buttonBar.png'));
    _topBar.renderFlipY = true;
    activeButton = null;

    for (int i = 0; i < buttonCount; i++) {
      _buttons.add(SpecialAttackBtn(AttackType.Normal, 0));
    }
  }

  void onTapDown(TapDownDetails detail, Player player) {
    if (_buttonBar.toRect().contains(detail.globalPosition)) {
      player.move = false;
    }
    for (int i = 0; i < _buttons.length; i++) {
      if (_buttons[i].toRect().contains(detail.globalPosition)) {
        player.move = false;
        if (_buttons[i].type != AttackType.Normal) {
          if (_buttons[i].isActive) {
            _buttons[i].isActive = false;
            player.attackType = AttackType.Normal;
          } else {
            _buttons.forEach((element) {
              element.isActive = false;
            });
            _buttons[i].isActive = true;
            player.attackType = _buttons[i].getAttackType();
          }
        }
      }
    }
  }

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

  void resize() {
    _buttonBar.width = screenSize.width * 0.25;
    _buttonBar.height = screenSize.height * 0.10;
    _buttonBar.x = screenSize.width * 0.375;
    _buttonBar.y = screenSize.height * 0.90;
    y = screenSize.height - screenSize.height * 0.16;

    _topBar.width = screenSize.width * 0.60;
    _topBar.height = screenSize.height * 0.10;
    _topBar.x = screenSize.width * 0.2;
    _topBar.y = 0;
    double barWidth = screenSize.width * 0.05 * _buttons.length +
        screenSize.width * 0.03 * (_buttons.length - 1);

    firstBtnX = (screenSize.width - barWidth) / 2;

    double pushDistance = 0;

    _buttons.forEach((element) {
      element.x = firstBtnX + pushDistance;
      element.y = y;
      pushDistance += screenSize.width * 0.07;
      element.resize();
    });
  }

  void update(double t) {
    for (int i = 0; i < _buttons.length; i++) {
      if (_buttons[i].type != AttackType.Normal && _buttons[i].count <= 0) {
        _buttons[i] = SpecialAttackBtn(AttackType.Normal, 0);
        _buttons[i].count = 0;
        resize();
      }
      _buttons[i].update(t);
    }
  }

  void addSlot() {
    if (_buttons.length < 3) {
      _buttons.add(SpecialAttackBtn(AttackType.Normal, 0));
      resize();
    }
  }

  void addAttack(AttackType type, int count) {
    for (int i = 0; i < _buttons.length; i++) {
      if (_buttons[i].type == AttackType.Normal) {
        _buttons[i] = SpecialAttackBtn(type, count);
        resize();
        break;
      } else if (_buttons[i].type == type) {
        _buttons[i].count += count;
        break;
      }
    }
  }

  void deactivateAll() {
    _buttons.forEach((element) {
      element.isActive = false;
    });
  }

  void reduceCount(AttackType type) {
    for (int i = 0; i < _buttons.length; i++) {
      if (type != AttackType.Normal && _buttons[i].type == type) {
        _buttons[i].count -= 1;
        if (type == AttackType.Tree) {
          _buttons.removeAt(i);
        }
      }
    }
  }

  void addTree() {
    _buttons.add(SpecialAttackBtn(AttackType.Tree, 1));
    resize();
  }
}
