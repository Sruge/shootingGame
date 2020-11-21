import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:shootinggame/screens/BaseWidget.dart';
import 'package:shootinggame/screens/game_screens/ButtonType.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';
import 'package:shootinggame/screens/util/Background.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';

import 'GameButton.dart';

class MainScreen extends BaseWidget {
  Background _bg;
  GameButton _newGame;
  GameButton _continueGame;
  GameButton _char1;
  GameButton _char2;
  GameButton _char3;
  PositionComponent _title;
  int _activeChar;
  MainScreen() {
    _bg = Background('playground.png');
    _activeChar = 0;
    _newGame = GameButton(
      ButtonType.Normal,
      'newGameBtn.png',
    );
    _continueGame = GameButton(
      ButtonType.Normal,
      'continueBtn.png',
    );
    _char1 = GameButton(
      ButtonType.Toggle,
      'elfsingle.png',
    );
    _char2 = GameButton(
      ButtonType.Toggle,
      'elf2single.png',
    );
    _char3 = GameButton(
      ButtonType.Toggle,
      'elf3single.png',
    );
    _title = SpriteComponent.fromSprite(0, 0, Sprite('title.png'));
  }
  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (_newGame.toRect().contains(detail.globalPosition) && _activeChar != 0) {
      screenManager.startNewGame(_activeChar);
    } else if (_continueGame.toRect().contains(detail.globalPosition)) {
      screenManager.switchScreen(ScreenState.kPlayScreen);
    } else if (_char1.toRect().contains(detail.globalPosition)) {
      _activeChar = 1;
      _char1.toggled = true;
      _char2.toggled = false;
      _char3.toggled = false;
    } else if (_char2.toRect().contains(detail.globalPosition)) {
      _activeChar = 2;
      _char1.toggled = false;
      _char2.toggled = true;
      _char3.toggled = false;
    } else if (_char3.toRect().contains(detail.globalPosition)) {
      _activeChar = 3;
      _char1.toggled = false;
      _char2.toggled = false;
      _char3.toggled = true;
    }
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    canvas.save();
    _title.render(canvas);
    canvas.restore();
    _newGame.render(canvas);
    _continueGame.render(canvas);
    _char1.render(canvas);
    _char2.render(canvas);
    _char3.render(canvas);
  }

  @override
  void resize() {
    _bg.resize();
    _newGame.x = screenSize.width * 0.16;
    _newGame.y = screenSize.height * 0.6;
    _newGame.width = screenSize.width * 0.26;
    _newGame.height = screenSize.height * 0.24;

    _continueGame.x = screenSize.width * 0.58;
    _continueGame.y = screenSize.height * 0.6;
    _continueGame.width = screenSize.width * 0.26;
    _continueGame.height = screenSize.height * 0.24;

    _char1.x = screenSize.width * 0.16;
    _char1.y = screenSize.height * 0.36;
    _char1.width = screenSize.width * 0.08;
    _char1.height = screenSize.height * 0.2;

    _char2.x = screenSize.width * 0.25;
    _char2.y = screenSize.height * 0.36;
    _char2.width = screenSize.width * 0.08;
    _char2.height = screenSize.height * 0.2;

    _char3.x = screenSize.width * 0.34;
    _char3.y = screenSize.height * 0.36;
    _char3.width = screenSize.width * 0.08;
    _char3.height = screenSize.height * 0.2;

    _title.x = screenSize.width * 0.15;
    _title.y = screenSize.height * 0.07;
    _title.width = screenSize.width * 0.7;
    _title.height = screenSize.height * 0.25;
    _char1.resize();
    _char2.resize();
    _char3.resize();
  }

  @override
  void update(double t) {
    _bg.update(t);
    _char1.update(t);
  }
}
