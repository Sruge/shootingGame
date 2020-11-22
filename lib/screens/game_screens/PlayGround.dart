import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flutter/src/gestures/tap.dart';
import 'package:flutter/widgets.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/Bullet.dart';
import 'package:shootinggame/screens/game_screens/ScreenManager.dart';
import 'package:shootinggame/screens/game_screens/TableOverlay.dart';
import 'package:shootinggame/screens/player/Player.dart';
import 'package:shootinggame/screens/game_screens/ScreenState.dart';
import 'package:shootinggame/screens/util/DynamicBackground.dart';
import 'package:shootinggame/screens/util/SizeHolder.dart';
import 'package:shootinggame/screens/util/StoryHandler.dart';

import '../BaseWidget.dart';

class PlayGround extends BaseWidget {
  DynamicBackground _bg;

  Player _player;
  List<double> speed = [0, 0];

  double speedfactor;
  StoryHandler _storyHandler;
  bool showDeal;
  TableOverlay _table;

  PlayGround(int char) {
    _bg = DynamicBackground(0, 0, 'playground.png');

    _player = Player(char);
    speedfactor = 0.2;
    _storyHandler = StoryHandler();
    showDeal = false;
  }
  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    print(speedfactor);
    if (showDeal && _table.contains(detail.globalPosition)) {
      _table.onTapDown(detail, _player);
    } else {
      showDeal = false;
      speed = getSpeed(detail);
      _player.onTapDown(
          detail, _storyHandler.getEnemies(), _storyHandler.friends, speed, () {
        screenManager.switchScreen(ScreenState.kMenuScreen);
      });

      if (_player.move) _bg.onTapDown(detail, speed);
    }
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    _storyHandler.render(canvas);
    _player.render(canvas);
    if (showDeal) _table.render(canvas);
  }

  @override
  void resize() {
    _bg.resize();

    _player.resize();
    _storyHandler.resize();
  }

  @override
  void update(double t) {
    _player.speedfactor = speedfactor;
    if (_bg.hasReachedDestinationOrBorder()) _player.move = false;
    if (!_player.move) speed = [0, 0];

    _bg.update(t, speed);
    _player.update(
        t, speed, _storyHandler.getEnemies(), _storyHandler.getPresents());
    _storyHandler.update(t, speed, _player);
  }

  List<double> getSpeed(TapDownDetails detail) {
    List<double> speed = [0, 0];
    double sumOffsets =
        (detail.globalPosition.dx - screenSize.width / 2).abs() +
            (detail.globalPosition.dy - screenSize.height / 2).abs();
    if (detail.globalPosition.dx - screenSize.width / 2 > 0) {
      speed[0] = speedfactor *
          ((detail.globalPosition.dx - screenSize.width / 2).abs() /
              sumOffsets);
    } else {
      speed[0] = -speedfactor *
          ((detail.globalPosition.dx - screenSize.width / 2).abs() /
              sumOffsets);
    }
    if (detail.globalPosition.dy - screenSize.height / 2 > 0) {
      speed[1] = speedfactor *
          ((detail.globalPosition.dy - screenSize.height / 2).abs() /
              sumOffsets);
    } else {
      speed[1] = -speedfactor *
          ((detail.globalPosition.dy - screenSize.height / 2).abs() /
              sumOffsets);
    }

    return speed;
  }

  void openDeal(double x, double y) {
    _table = TableOverlay(x, y);
    _table.resize();
    showDeal = true;
  }

  void setSpeed(List<double> speed) {
    print('setting playgroujnd speed');
    speed = [speed[0], speed[1]];
  }
}
