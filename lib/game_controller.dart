import 'dart:ui';
import 'package:BWO/Effects/EffectsController.dart';
import 'package:BWO/Entity/Player.dart';
import 'package:BWO/Map/map_controller.dart';
import 'package:BWO/Utils/PhysicsController.dart';
import 'package:flame/anchor.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flame/position.dart';
import 'package:flame/text_config.dart';
import 'package:flutter/material.dart';

class GameController extends Game with PanDetector {
  static Size screenSize;
  double fps;
  TextConfig config =
      TextConfig(fontSize: 12.0, color: Colors.white, fontFamily: "Blocktopia");

  static const int worldSize = 16;
  static double deltaTime = 0;
  static double time = 0;
  static int tapState = TapState.UP;
  static int preTapState = TapState.UP;
  MapController mapController = new MapController();
  PhysicsController physicsController;
  Player player;

  GameController() {
    physicsController = new PhysicsController(mapController);
    player = new Player(0, 0, mapController);
    mapController.addEntity(player);

    Flame.bgm.initialize();
    Flame.bgm.play('recovery.mp3', volume: .3);
    Flame.audio.loadAll(['footstep_grass1.mp3', 'footstep_grass2.mp3']);
  }

  void render(Canvas c) {
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff000000);
    c.drawRect(bgRect, bgPaint);

    mapController.drawMap(c, player.x, player.y, bgRect,
        movimentType: MovimentType.FOLLOW, tileSize: worldSize);

    config.render(c, "FPS: ${fps.isNaN || fps.isInfinite ? 0 : fps.toInt()}",
        Position(10, 10),
        anchor: Anchor.topLeft);
    config.render(c, "Trees: ${mapController.treesGenerated}", Position(10, 20),
        anchor: Anchor.topLeft);
    config.render(c, "Tiles: ${mapController.tilesGenerated}", Position(10, 30),
        anchor: Anchor.topLeft);
    config.render(
        c, "Location: ${player.posX}, ${player.posY}", Position(10, 40),
        anchor: Anchor.topLeft);
    physicsController.update();

    EffectsController.draw(c);
  }

  void update(double dt) {
    fps = 1.0 / dt;
    deltaTime = dt;
    time += dt;

    if (preTapState == TapState.DOWN) {
      tapState = TapState.DOWN;
      preTapState = TapState.UP;
    }

    player.update();
    physicsController.update();

    if (tapState == TapState.DOWN) {
      tapState = TapState.PRESSING;
    }
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
  }

  @override
  void onPanDown(DragDownDetails details) {
    preTapState = TapState.DOWN;
    TapState.localPosition = details.localPosition;
  }

  @override
  void onPanEnd(DragEndDetails details) {
    tapState = TapState.UP;
  }
}

class TapState {
  static const int UP = 0;
  static const int DOWN = 1;
  static const int PRESSING = 2;
  static const int CANCEL = 3;

  static Offset localPosition;

  static bool isTapingLeft() {
    return GameController.tapState == PRESSING &&
        localPosition.dx < GameController.screenSize.width / 2;
  }

  static bool isTapingRight() {
    return GameController.tapState == PRESSING &&
        localPosition.dx > GameController.screenSize.width / 2;
  }
}
