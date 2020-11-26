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

  List<EnemyType> enemyTypes;
  List<PresentType> presentTypes;
  List<Enemy> bosses;
  Random _random;
  Level(int level) {
    _random = Random();
    spawnInterval = 12 + _random.nextInt(4).toDouble();
    bossSpawnInterval = 40 + _random.nextInt(60).toDouble();
    friendSpawnInterval = 12;
    presentSpawnInterval = 12;
    treeSpawnInterval = 80;
    timeToNextLevel = 80;

    dmgMultiplier = 1;
    bulletLifetimeMultiplier = 0.7;
    attackRangeMultiplier = 1;
    attackIntervalMultiplier = 1;
    healthMulti = 1;
    enemySpeedMultiplier = 0.2;
    enemyBulletSpeed = 1;

    maxEnemies = 4;
    enemyTypes = [EnemyType.One];
    bosses = List.empty(growable: true);
    presentTypes = [
      PresentType.Bullets,
      PresentType.Health,
      PresentType.Coin,
      PresentType.Blue,
      PresentType.Colored,
      PresentType.Golden,
      PresentType.Red
    ];
    if (level >= 0) {
      Kainhighwind boss = Kainhighwind();
      boss.resize();
      bosses.add(boss);

      // Killer killer = Killer();
      // killer.resize();
      // bosses.add(killer);

      // Phoenix phoenix = Phoenix();
      // phoenix.resize();
      // bosses.add(phoenix);

      // Russia russia = Russia();
      // russia.resize();
      // bosses.add(russia);

      // Leviathan leviathan = Leviathan();
      // leviathan.resize();
      // bosses.add(leviathan);
      spawnInterval = 15 + _random.nextInt(4).toDouble();
    }
    if (level > 1) {
      enemyTypes.add(EnemyType.Two);

      Killer killer = Killer();
      killer.resize();
      bosses.add(killer);

      enemyBulletSpeed = 1.1;
      enemySpeedMultiplier = 0.2;

      bulletLifetimeMultiplier = 1;
      healthMulti = 5;
      dmgMultiplier = 1.2;
      attackIntervalMultiplier = 0.9;
      healthMulti = 1.5;

      spawnInterval = 15 + _random.nextInt(4).toDouble();
    }
    if (level > 1) {
      Phoenix phoenix = Phoenix();
      phoenix.resize();
      bosses.add(phoenix);
      enemyBulletSpeed = 1.2;
      enemySpeedMultiplier = 0.3;
      attackIntervalMultiplier = 0.5;
      dmgMultiplier = 2;
      healthMulti = 1.7;
      bulletLifetimeMultiplier = 2;
      spawnInterval = 13 + _random.nextInt(4).toDouble();
    }
    if (level > 4) {
      enemyTypes.add(EnemyType.Three);

      Russia russia = Russia();
      russia.resize();
      bosses.add(russia);
      attackIntervalMultiplier = 1.2;
      dmgMultiplier = 2.5;
      healthMulti = 2;
      spawnInterval = 10 + _random.nextInt(4).toDouble();
    }
    if (level > 5) {
      Princessserenity princessserenity = Princessserenity();
      princessserenity.resize();
      bosses.add(princessserenity);
      spawnInterval = 6;
      enemySpeedMultiplier = 0.35;
      attackIntervalMultiplier = 0.8;
      spawnInterval = 26 + _random.nextInt(10).toDouble();
    }
    if (level > 6) {
      enemyTypes.add(EnemyType.Four);
      enemyTypes.add(EnemyType.Five);

      Leviathan leviathan = Leviathan();
      leviathan.resize();
      bosses.add(leviathan);

      enemyBulletSpeed = 1.4;
      dmgMultiplier = 4;
      healthMulti = 3;

      spawnInterval = 6 + _random.nextInt(10).toDouble();
    }
    if (level > 7) {
      enemyTypes.add(EnemyType.Six);

      Altima altima = Altima();
      altima.resize();
      bosses.add(altima);
      healthMulti = 8;
    }
    if (level > 8) {
      Boss kainhighwind = Boss();
      kainhighwind.resize();
      bosses.add(kainhighwind);
      enemyBulletSpeed = 1.6;
      dmgMultiplier = 6;
      healthMulti = 5;
      spawnInterval = 4 + _random.nextInt(10).toDouble();
    }
    if (level > 9) {
      enemyTypes.add(EnemyType.PirateOne);
      enemyTypes.add(EnemyType.PirateTwo);
      enemyTypes.add(EnemyType.PirateThree);

      Bahamut bahamut = Bahamut();
      bahamut.resize();
      bosses.add(bahamut);

      enemySpeedMultiplier = 2;
      spawnInterval = 1 + _random.nextInt(10).toDouble();
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
