import 'dart:html';
import 'dart:math';

import '../utils/utils.dart';
import 'gameObject.dart';
import 'point.dart';

enum GraffitiArtsType {
  one,
  two,
  three,
  four,
  five,
  six,
}

class GraffitiArt extends GameObject {
  CanvasElement? mask;
  GraffitiArtsType type;

  static getRandomGraffitiArt() {
    return GraffitiArtsType.values[Random().nextInt(GraffitiArtsType.values.length)];
  }

  GraffitiArt({
    required super.x,
    required super.y,
    super.height = 60,
    super.width = 60,
    super.angle = 0,
    this.type = GraffitiArtsType.one,
  }) {
    solid = false;
    damageable = false;

    mask = document.createElement("canvas") as CanvasElement;
    mask!.width = width;
    mask!.height = height;

    createMask(width, height, "assets/images/graffiti${type.index + 1}.png", mask!);
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
