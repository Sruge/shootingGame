import 'dart:math';

import 'package:shootinggame/enemies/bosses/Altima.dart';
import 'package:shootinggame/enemies/bosses/Bahamut.dart';
import 'package:shootinggame/enemies/bosses/Boss.dart';
import 'package:shootinggame/enemies/Enemy.dart';
import 'package:shootinggame/enemies/EnemyType.dart';
import 'package:shootinggame/enemies/PresentType.dart';
import 'package:shootinggame/enemies/bosses/Kainhighwind.dart';
import 'package:shootinggame/enemies/bosses/Killer.dart';
import 'package:shootinggame/enemies/bosses/Leviathan.dart';
import 'package:shootinggame/enemies/bosses/Phoenix.dart';
import 'package:shootinggame/enemies/bosses/Princessserenity.dart';
import 'package:shootinggame/enemies/bosses/Russia.dart';

class Level {
  double spawnInterval;
  double friendSpawnInterval;
  double bossSpawnInterval;
  double presentSpawnInterval;
  double maxEnemies;

  double dmgMultiplier;
  double bulletLifetimeMultiplier;
  double attackRangeMultiplier;
  double attackIntervalMultiplier;
  double enemySpeedMultiplier;
  double healthMulti;
  double timeToNextLevel;

  List<EnemyType> enemyTypes;
  List<PresentType> presentTypes;
  List<Enemy> bosses;
  Random _random;
  Level(int level) {
    _random = Random();
    spawnInterval = 10 + _random.nextInt(20).toDouble() - level * 0.1;
    bossSpawnInterval = 0 + _random.nextInt(10).toDouble();
    friendSpawnInterval = 3;
    presentSpawnInterval = 15;
    timeToNextLevel = 120;

    dmgMultiplier = 1;
    bulletLifetimeMultiplier = 1;
    attackRangeMultiplier = 1;
    attackIntervalMultiplier = 1 - level * 0.02;
    healthMulti = 1;
    enemySpeedMultiplier = 1;

    maxEnemies = 6;
    enemyTypes = [EnemyType.One];
    bosses = List.empty(growable: true);
    presentTypes = [
      PresentType.Bullets,
      PresentType.Health,
      PresentType.Coin,
      PresentType.Freeze
    ];
    if (level >= 0) {
      enemyTypes.add(EnemyType.Two);
      Kainhighwind boss = Kainhighwind();
      boss.resize();
      bosses.add(boss);
    }
    if (level > 2) {
      enemyTypes.add(EnemyType.Three);
      Killer killer = Killer();
      killer.resize();
      bosses.add(killer);
      bulletLifetimeMultiplier = 3;
      healthMulti = 5;
      enemySpeedMultiplier = 2;
      dmgMultiplier = 3;
    }
    if (level > 4) {
      Phoenix phoenix = Phoenix();
      phoenix.resize();
      bosses.add(phoenix);
      presentTypes.add(PresentType.Freeze);
      dmgMultiplier = 2;
      spawnInterval = 7;
    }
    if (level > 6) {
      enemyTypes.add(EnemyType.Four);

      Russia russia = Russia();
      russia.resize();
      bosses.add(russia);
    }
    if (level > 7) {
      Princessserenity princessserenity = Princessserenity();
      princessserenity.resize();
      bosses.add(princessserenity);
      spawnInterval = 6;
    }
    if (level > 9) {
      enemyTypes.add(EnemyType.Five);
      Leviathan leviathan = Leviathan();
      leviathan.resize();
      bosses.add(leviathan);
    }
    if (level > 11) {
      Altima altima = Altima();
      altima.resize();
      bosses.add(altima);
    }
    if (level > 12) {
      Kainhighwind kainhighwind = Kainhighwind();
      kainhighwind.resize();
      bosses.add(kainhighwind);
    }
    if (level > 13) {
      Bahamut bahamut = Bahamut();
      bahamut.resize();
      bosses.add(bahamut);
    }
    print('Creating Level: $level: ${this.toString()}');
  }

  String toString() {
    String level = 'EnemyTypes: $enemyTypes, Bosses: $bosses, PresentTypes: $presentTypes, ' +
        'SpawnInterval: $spawnInterval BossSpawnInterval: $bossSpawnInterval, FriendSpawninterval: $friendSpawnInterval, PresentSpawnInterval: $presentSpawnInterval, ' +
        'Damage: $dmgMultiplier, BulletLifeTime: $bulletLifetimeMultiplier, AttackRange: $attackRangeMultiplier, AttackInterval: $attackIntervalMultiplier, ' +
        'SpeedMultiplier: $enemySpeedMultiplier, HealthMulti: $healthMulti, Duration: $timeToNextLevel';
    return level;
  }
}
