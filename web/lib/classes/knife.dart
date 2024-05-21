import 'dart:html';
import 'dart:math';

import 'gameObject.dart';
import 'point.dart';

class Knife extends GameObject {
  double speed = 0;
  double acceleration;
  double maxSpeed;

  Knife({
    this.acceleration = 0.005,
    this.maxSpeed = 3,
    this.speed = 0,
    required super.x,
    required super.y,
    super.height = 5,
    required super.width,
  }) {
    damageable = false;
  }

  @override
  void draw(CanvasRenderingContext2D ctx) {
    ctx.fillStyle = 'rgba(255, 75, 75, 1)';

    ctx.beginPath();
    ctx.moveTo(polygon[0].x, polygon[0].y);

    for (var i = 1; i < polygon.length; i++) {
      ctx.lineTo(polygon[i].x, polygon[i].y);
    }

    ctx.fill();
  }

  @override
  update(List<List<Point>> roadBorders, List<GameObject> traffic) {
    move();
    polygon = createPolygon();
  }

  @override
  void move() {
    speed += acceleration;

    if (speed > maxSpeed) {
      speed = maxSpeed;
    }

    if (speed < -maxSpeed / 2) {
      speed = -maxSpeed / 2;
    }

    if (speed < 0) {
      speed = 0;
    }

    x -= (sin(0) * speed);
    y -= (cos(0) * speed);
  }

  @override
  void dispose() {
    //
  }
}
