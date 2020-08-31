import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../game_controller.dart';
import 'tool_item.dart';

class BuildSubToolsBar {
  final Paint _p = Paint();
  Rect bounds;

  double _boxHeight = -144;
  double _heightTarget = -144;

  List<ToolItem> buttonList = [];

  bool _isActive = false;

  BuildSubToolsBar() {
    setActive(true);
  }

  void draw(Canvas c) {
    _p.color = Color.fromRGBO(220, 210, 150, 1);
    bounds = Rect.fromLTRB(
      55,
      GameController.screenSize.height - _boxHeight,
      GameController.screenSize.width - 55,
      GameController.screenSize.height + 15,
    );
    var rBounds = RRect.fromLTRBR(bounds.left, bounds.top, bounds.right,
        bounds.bottom, Radius.circular(15));

    openCloseAnimation();
    c.drawRRect(rBounds, _p);

    if (rBounds.top <= GameController.screenSize.height) {
      c.drawRRect(rBounds, _p);
      drawButtonsOnPosition(c);
    }
  }

  void openCloseAnimation() {
    _boxHeight =
        lerpDouble(_boxHeight, _heightTarget, GameController.deltaTime * 5);
  }

  // ignore: avoid_positional_boolean_parameters
  void setActive(bool isActive) {
    _isActive = isActive;

    if (_isActive) {
      _boxHeight = -15;
      _heightTarget = 144;
    } else {
      _boxHeight = 144;
      _heightTarget = -15;
    }
  }

  void drawButtonsOnPosition(Canvas c) {
    c.save();
    c.clipRect(bounds);
    for (var i = 0; i < buttonList.length; i++) {
      var spaceBetween = (bounds.width / buttonList.length);
      spaceBetween = spaceBetween.clamp(64.0, double.infinity);

      buttonList[i].pos = Offset(
        bounds.left + (spaceBetween * i) + spaceBetween / 2,
        bounds.top + 30,
      );
      buttonList[i].draw(c);
    }
    c.restore();
  }

  void selectButtonHightlight(ToolItem bt) {
    for (var button in buttonList) {
      button.isSelected = button == bt;
    }
  }
}
