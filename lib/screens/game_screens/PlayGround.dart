import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:shootinggame/friends/DealerBord.dart';
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

  Player player;
  List<double> speed = [0, 0];

  double speedfactor;
  StoryHandler storyHandler;
  bool showDeal;
  DealerBord _dealerBord;

  PlayGround(int char) {
    _bg = DynamicBackground(0, 0, 'bg.png');

    player = Player(char);
    speedfactor = 0.2;
    storyHandler = StoryHandler();
    showDeal = false;
  }
  @override
  void onTapDown(TapDownDetails detail, Function fn) {
    if (showDeal &&
        _dealerBord.table.toRect().contains(detail.globalPosition)) {
      _dealerBord.onTapDown(detail, player);
    } else {
      showDeal = false;
      speed = getSpeed(detail);
      player.onTapDown(
          detail, storyHandler.getEnemies(), storyHandler.friends, speed, () {
        screenManager.switchScreen(ScreenState.kMenuScreen);
      });

      if (player.move) _bg.onTapDown(detail, speed);
    }
  }

  @override
  void render(Canvas canvas) {
    _bg.render(canvas);
    storyHandler.render(canvas);
    player.render(canvas);
    if (showDeal) _dealerBord.render(canvas);
  }

  @override
  void resize() {
    _bg.resize();

    player.resize();
    storyHandler.resize();
  }

  @override
  void update(double t) {
    player.speedfactor = speedfactor;
    if (_bg.hasReachedDestinationOrBorder()) player.move = false;
    if (!player.move) speed = [0, 0];

    _bg.update(t, speed);
    player.update(
        t, speed, storyHandler.getEnemies(), storyHandler.getPresents());
    storyHandler.update(t, speed, player);
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
    _dealerBord = DealerBord(true);
    _dealerBord.resize(x, y);
    showDeal = true;
  }
}
