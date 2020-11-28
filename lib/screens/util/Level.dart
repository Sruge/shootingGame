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

import 'StoryHandler.dart';

class Level {
  int level;
  double spawnInterval;
  double friendSpawnInterval;
  double bossSpawnInterval;
  double presentSpawnInterval;
  double treeSpawnInterval;
  double maxEnemies;

  double dmgMultiplier;
  double bulletLifetimeMultiplier;
  double attackRangeMultiplier;
  double attackIntervalMultiplier;
  double enemySpeedMultiplier;
  double healthMulti;
  double timeToNextLevel;
  double enemyBulletSpeed;
  double _bossPower;
  double treePower;

  List<EnemyType> enemyTypes;
  List<PresentType> presentTypes;
  List<Enemy> bosses;
  StoryHandler _storyHandler;
  Level(this.level, this._storyHandler) {
    bosses = List.empty(growable: true);

    spawnInterval = 10;
    bossSpawnInterval = 60;
    friendSpawnInterval = 30;
    presentSpawnInterval = 20;
    treeSpawnInterval = 100;
    timeToNextLevel = 30;

    _bossPower = 1;
    treePower = 1;
    dmgMultiplier = 1;
    bulletLifetimeMultiplier = 0.7;
    attackRangeMultiplier = 1;
    attackIntervalMultiplier = 1;
    healthMulti = 1;
    enemySpeedMultiplier = 0.2;
    enemyBulletSpeed = 1;

    maxEnemies = 6;
    enemyTypes = [EnemyType.One];
    presentTypes = [
      PresentType.Bullets,
      PresentType.Health,
      //PresentType.Coin,
      // PresentType.Colored,
      // PresentType.Golden,
      // PresentType.Red
    ];

    if (level > 0) {
      spawnInterval = 7;
    }
    if (level > 1) {
      // Kainhighwind boss = Kainhighwind(_bossPower, _storyHandler);
      // boss.resize();
      // bosses.add(boss);

      // Killer killer = Killer(_bossPower);
      // killer.resize();
      // bosses.add(killer);

      // Phoenix phoenix = Phoenix(2);
      // phoenix.resize();
      // bosses.add(phoenix);

      // Russia russia = Russia();
      // russia.resize();
      // bosses.add(russia);

      // Leviathan leviathan = Leviathan();
      // leviathan.resize();
      // bosses.add(leviathan);

      // Boss boss = Boss(_bossPower);
      // boss.resize();
      // bosses.add(boss);

      spawnInterval = 6;
    }
    if (level > 2) {
      timeToNextLevel = 90;

      enemyTypes.add(EnemyType.Two);

      Russia russia = Russia(_bossPower, _storyHandler);
      russia.resize();
      bosses.add(russia);

      enemyBulletSpeed = 1.1;
      enemySpeedMultiplier = 0.2;

      bulletLifetimeMultiplier = 1;
      dmgMultiplier = 1.2;
      attackIntervalMultiplier = 0.9;
      healthMulti = 1.5;
      spawnInterval = 10;
    }
    if (level > 3) {
      timeToNextLevel = 120;

      Phoenix phoenix = Phoenix(_bossPower, _storyHandler);
      phoenix.resize();
      bosses.add(phoenix);
      enemyBulletSpeed = 1.2;
      enemySpeedMultiplier = 0.24;
      attackIntervalMultiplier = 0.5;
      dmgMultiplier = 2;
      healthMulti = 1.7;
      bulletLifetimeMultiplier = 2;
      spawnInterval = 10;
    }
    if (level > 4) {
      timeToNextLevel = 150;
      presentTypes.add(PresentType.Golden);
      presentTypes.add(PresentType.Colored);
      enemyTypes.add(EnemyType.Three);
      Boss boss = Boss(_bossPower);
      boss.resize();
      bosses.add(boss);

      Killer killer = Killer(_bossPower, _storyHandler);
      killer.resize();
      bosses.add(killer);
      attackIntervalMultiplier = 1.2;
      dmgMultiplier = 2.5;
      healthMulti = 2;
      spawnInterval = 10;
    }
    if (level > 5) {
      timeToNextLevel = 180;
      enemyTypes.add(EnemyType.Four);

      Princessserenity princessserenity =
          Princessserenity(_bossPower, _storyHandler);
      princessserenity.resize();
      bosses.add(princessserenity);
      spawnInterval = 6;
      enemySpeedMultiplier = 0.28;
      attackIntervalMultiplier = 0.8;
      spawnInterval = 26;
    }
    if (level > 6) {
      timeToNextLevel = 210;
      presentTypes.add(PresentType.Red);
      enemyTypes.add(EnemyType.Five);

      Leviathan leviathan = Leviathan(_bossPower, _storyHandler);
      leviathan.resize();
      bosses.add(leviathan);

      enemyBulletSpeed = 1.4;
      dmgMultiplier = 4;
      healthMulti = 3;

      spawnInterval = 6;
    }
    if (level > 7) {
      timeToNextLevel = 240;
      _bossPower *= 1.5;
      enemyTypes.add(EnemyType.Six);

      Altima altima = Altima(_bossPower, _storyHandler);
      altima.resize();
      bosses.add(altima);
      healthMulti = 8;
    }
    if (level > 8) {
      timeToNextLevel = 270;
      Kainhighwind kainhighwind = Kainhighwind(_bossPower, _storyHandler);
      kainhighwind.resize();
      bosses.add(kainhighwind);
      enemyBulletSpeed = 1.6;
      dmgMultiplier = 6;
      healthMulti = 5;
      spawnInterval = 4;
    }
    if (level > 9) {
      timeToNextLevel = 300;
      enemyTypes.add(EnemyType.PirateOne);
      enemyTypes.add(EnemyType.PirateTwo);
      enemyTypes.add(EnemyType.PirateThree);

      Bahamut bahamut = Bahamut(_bossPower, _storyHandler);
      bahamut.resize();
      bosses.add(bahamut);

      enemySpeedMultiplier = 0.4;
      spawnInterval = 1;
      _bossPower *= 1.5;
    }
    if (level > 10) {
      timeToNextLevel = 360;
      _bossPower += (level - 10) * 0.2;
      healthMulti += level - 10;
      dmgMultiplier += level - 10;
    }
    print('Creating Level: $level: ${this.toString()}');
  }

  String toString() {
    String level = 'EnemyTypes: $enemyTypes, Bosses: $bosses, PresentTypes: $presentTypes, ' +
        'SpawnInterval: $spawnInterval BossSpawnInterval: $bossSpawnInterval, FriendSpawninterval: $friendSpawnInterval, PresentSpawnInterval: $presentSpawnInterval, TreeSpawnInterval: $treeSpawnInterval ' +
        'Damage: $dmgMultiplier, BulletLifeTime: $bulletLifetimeMultiplier, AttackRange: $attackRangeMultiplier, AttackInterval: $attackIntervalMultiplier, ' +
        'SpeedMultiplier: $enemySpeedMultiplier, BulletSpeedMultiplier: $enemyBulletSpeed HealthMulti: $healthMulti, Duration: $timeToNextLevel';
    return level;
  }
}
