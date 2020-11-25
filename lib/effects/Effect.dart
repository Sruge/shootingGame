import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/EffectState.dart';
import 'package:shootinggame/effects/EffectType.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/screens/game_screens/PlayGround.dart';
import 'package:shootinggame/screens/player/Player.dart';

import 'package:shootinggame/screens/util/SizeHolder.dart';

class Effect {
  EffectType type;
  AnimationComponent effect;
  bool renderSomething;
  double timer, totalDuration;
  Player player;
  Enemy enemy;
  EffectState state;
  Effect(this.type, String imgUrl, this.player, this.enemy) {
    state = EffectState.Active;
    timer = 0;
    totalDuration = 2;
    if (imgUrl.isNotEmpty) {
      renderSomething = true;
      final sprShe = SpriteSheet(
          imageName: imgUrl,
          textureWidth: 32,
          textureHeight: 32,
          columns: 4,
          rows: 1);
      final ani = sprShe.createAnimation(0, stepTime: 0.1);
      effect = AnimationComponent(0, 0, ani);
    } else {
      renderSomething = false;
    }
  }

  void render(Canvas canvas) {
    if (renderSomething) {
      canvas.save();
      effect.render(canvas);
      canvas.restore();
    }
  }

  void update(double t, double x, double y) {
    timer += t;
    effect.x = x;
    effect.y = y;
    if (timer > totalDuration) end();

    if (renderSomething) {
      effect.update(t);
    }
  }

  void resize(double x, double y) {
    if (renderSomething) {
      effect.x = x;
      effect.y = y;
      effect.width = screenSize.width * 0.06;
      effect.height = screenSize.height * 0.14;
    }
  }

  void end() {
    state = EffectState.Ended;
  }
}
