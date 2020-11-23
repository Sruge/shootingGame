import 'dart:ui';

import 'package:flame/components/animation_component.dart';
import 'package:flame/spritesheet.dart';
import 'package:shootinggame/effects/EffectType.dart';

import 'package:shootinggame/screens/util/SizeHolder.dart';

class Effect {
  EffectType type;
  AnimationComponent effect;
  bool renderSomething;
  Effect(this.type, String imgUrl) {
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
    if (renderSomething) {
      effect.x = x;
      effect.y = y;
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

  EffectType getType() {
    return type;
  }
}
