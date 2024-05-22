import 'dart:html';
import 'dart:math';

import '../utils/utils.dart';
import 'gameObject.dart';
import 'point.dart';

enum TrafficLanesType {
  crossWalk,
  yellowStrip,
}

class TrafficLane extends GameObject {
  CanvasElement? mask;
  TrafficLanesType type;

  static getRandomTrafficLane() {
    return TrafficLanesType.values[Random().nextInt(TrafficLanesType.values.length)];
  }

  TrafficLane({
    required super.x,
    required super.y,
    super.height = 60,
    super.width = 60,
    super.angle = 0,
    this.type = TrafficLanesType.crossWalk,
  }) {
    solid = false;
    damageable = false;

    mask = document.createElement("canvas") as CanvasElement;
    mask!.width = width;
    mask!.height = height;

    createMask(width, height, "assets/images/${["crosswalk", "yellowStripe"][type.index]}.png", mask!);
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
