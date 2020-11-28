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
  GameButton _continueGameDis;
  GameButton _credits;
  GameButton _highscore;
  GameButton _char1;
  GameButton _char2;
  GameButton _char3;
  GameButton _activeCharPic;
  PositionComponent _title;
  int activeChar;
  int playingChar;
  bool gameActive;
  MainScreen() {
    gameActive = false;
    _bg = Background('bg.png');
    activeChar = 0;
    playingChar = 0;
    _newGame = GameButton(
      ButtonType.Normal,
      'newGameBtn2.png',
    );
    _continueGame = GameButton(
      ButtonType.Normal,
      'continueBtn2.png',
    );
    _continueGameDis = GameButton(
      ButtonType.Normal,
      'continueBtn2disabled.png',
    );
    _credits = GameButton(
      ButtonType.Normal,
      'creditsBtn.png',
    );
    _highscore = GameButton(
      ButtonType.Normal,
      'highscoreBtn.png',
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
    _char3 = GameButton(
      ButtonType.Toggle,
      'elf3single.png',
    );
    _title = SpriteComponent.fromSprite(0, 0, Sprite('title.png'));
  }
  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (_newGame.toRect().contains(detail.globalPosition) && activeChar != 0) {
      screenManager.startNewGame(activeChar);
    } else if (_continueGame.toRect().contains(detail.globalPosition) &&
        gameActive) {
      screenManager.switchScreen(ScreenState.kPlayScreen);
    } else if (_char1.toRect().contains(detail.globalPosition)) {
      activeChar = 1;
      screenManager.playingChar = 1;
      _char1.toggled = true;
      _char2.toggled = false;
      _char3.toggled = false;
    } else if (_char2.toRect().contains(detail.globalPosition)) {
      activeChar = 2;
      screenManager.playingChar = 2;
      _char1.toggled = false;
      _char2.toggled = true;
      _char3.toggled = false;
    } else if (_char3.toRect().contains(detail.globalPosition)) {
      activeChar = 3;
      screenManager.playingChar = 3;
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
    if (gameActive && playingChar != 0) {
      _continueGame.render(canvas);
      _activeCharPic.render(canvas);
    } else {
      _continueGameDis.render(canvas);
    }
    _credits.render(canvas);
    _highscore.render(canvas);
    _char1.render(canvas);
    _char2.render(canvas);
    _char3.render(canvas);
  }

  @override
  void resize() {
    _bg.resize();
    _newGame.x = screenSize.width * 0.08;
    _newGame.y = screenSize.height * 0.6;
    _newGame.width = screenSize.width * 0.27;
    _newGame.height = screenSize.height * 0.2;

    _continueGame.x = screenSize.width * 0.365;
    _continueGame.y = screenSize.height * 0.6;
    _continueGame.width = screenSize.width * 0.27;
    _continueGame.height = screenSize.height * 0.2;

    _continueGameDis.x = screenSize.width * 0.365;
    _continueGameDis.y = screenSize.height * 0.6;
    _continueGameDis.width = screenSize.width * 0.27;
    _continueGameDis.height = screenSize.height * 0.2;

    _credits.x = screenSize.width * 0.65;
    _credits.y = screenSize.height * 0.36;
    _credits.width = screenSize.width * 0.27;
    _credits.height = screenSize.height * 0.2;

    _highscore.x = screenSize.width * 0.65;
    _highscore.y = screenSize.height * 0.6;
    _highscore.width = screenSize.width * 0.27;
    _highscore.height = screenSize.height * 0.2;

    _char1.x = screenSize.width * 0.08;
    _char1.y = screenSize.height * 0.36;
    _char1.width = screenSize.width * 0.08;
    _char1.height = screenSize.height * 0.2;

    _char2.x = screenSize.width * 0.175;
    _char2.y = screenSize.height * 0.36;
    _char2.width = screenSize.width * 0.08;
    _char2.height = screenSize.height * 0.2;

    _char3.x = screenSize.width * 0.27;
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
    if (playingChar == 1) {
      _activeCharPic = GameButton(
        ButtonType.Normal,
        'elfsingle.png',
      );
    }
    if (playingChar == 2) {
      _activeCharPic = GameButton(
        ButtonType.Normal,
        'elf2single.png',
      );
    }
    if (playingChar == 3) {
      _activeCharPic = GameButton(
        ButtonType.Normal,
        'elf3single.png',
      );
    }
    if (playingChar != 0) {
      _activeCharPic.x = screenSize.width * 0.46;
      _activeCharPic.y = screenSize.height * 0.36;
      _activeCharPic.width = screenSize.width * 0.08;
      _activeCharPic.height = screenSize.height * 0.2;
      _activeCharPic.resize();
    }
  }

  @override
  void update(double t) {}
}
