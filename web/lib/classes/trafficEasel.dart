import 'dart:html';

import '../utils/utils.dart';
import 'gameObject.dart';
import 'point.dart';

class TrafficEasel extends GameObject {
  CanvasElement? mask;

  TrafficEasel({
    required super.x,
    required super.y,
    super.height = 11,
    super.width = 32,
    super.angle = 0,
  }) {
    mask = document.createElement("canvas") as CanvasElement;
    mask!.width = width;
    mask!.height = height;

    createMask(width, height, "assets/images/trafficEasel.png", mask!);
  }

  @override
  void draw(CanvasRenderingContext2D ctx) {
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(-angle);

    ctx.drawImageToRect(
      damaged ? mask! : mask!,
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
    move();
    polygon = createPolygon();
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
