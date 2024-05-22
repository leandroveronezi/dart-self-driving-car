import 'dart:html';

import '../utils/utils.dart';
import 'gameObject.dart';
import 'point.dart';

enum PoliceOfficerType {
  one,
  two,
}

class PoliceOfficer extends GameObject {
  CanvasElement? mask;
  PoliceOfficerType type;

  PoliceOfficer({
    required super.x,
    required super.y,
    super.height = 18,
    super.width = 16,
    super.angle = 0,
    this.type = PoliceOfficerType.one,
  }) {
    solid = false;
    damageable = false;

    mask = document.createElement("canvas") as CanvasElement;
    mask!.width = width;
    mask!.height = height;

    createMask(width, height, "assets/images/${["policeOfficerOne", "policeOfficerTwo"][type.index]}.png", mask!);
  }

  @override
  void draw(CanvasRenderingContext2D ctx) {
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(-angle);

    ctx.drawImageToRect(
      mask!,
      Rectangle(
        -width / 2,
        -height / 2,
        width,
        height,
      ),
    );

    ctx.restore();
  }

  @override
  update(List<List<Point>> roadBorders, List<GameObject> traffic) {
    //
  }

  @override
  void move() {
    //
  }

  @override
  void dispose() {
    //
  }
}
