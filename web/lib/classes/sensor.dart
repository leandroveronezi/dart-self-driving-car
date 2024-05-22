import 'dart:html';
import 'dart:math';

import '../utils/utils.dart';
import 'gameObject.dart';
import 'point.dart';

class Sensor {
  int rayCount = 3;
  int rayLength = 150;
  double raySpread;
  List<List<Point>> rays = [];
  List<dynamic> readings = [];

  Sensor({
    this.rayCount = 3,
    this.rayLength = 150,
    this.raySpread = pi / 1.9,
  });

  update(x, y, angle, List<List<Point>> roadBorders, List<GameObject> traffic) {
    _castRay(x, y, angle);

    readings = [];

    for (var ray in rays) {
      readings.add(getReading(ray, roadBorders, traffic));
    }
  }

  getReading(ray, roadBorders, traffic) {
    var touches = [];

    for (var border in roadBorders) {
      var touch = getIntersection(
        ray[0],
        ray[1],
        border[0],
        border[1],
      );

      if (touch == null) {
        continue;
      }

      touches.add(touch);
    }

    for (var i = 0; i < traffic.length; i++) {
      var poly = traffic[i].polygon;

      for (var j = 0; j < poly.length; j++) {
        var touch = getIntersection(
          ray[0],
          ray[1],
          poly[j],
          poly[(j + 1) % poly.length],
        );

        if (touch == null) {
          continue;
        }

        touches.add(touch);
      }
    }

    if (touches.isEmpty) {
      return null;
    }

    var offsets = touches.map((e) => e.offset);

    var minOffset = offsets.reduce((min, b) => min < b ? min : b);

    return touches.firstWhere((e) => e.offset == minOffset);
  }

  _castRay(x, y, angle) {
    rays = [];

    for (int i = 0; i < rayCount; i++) {
      double rayAngle = lerpDouble(
            raySpread / 2,
            -raySpread / 2,
            rayCount == 1 ? 0.5 : i / (rayCount - 1),
          ) +
          angle;

      var start = Point(
        x: x,
        y: y,
      );

      var end = Point(
        x: x - sin(rayAngle) * rayLength,
        y: y - cos(rayAngle) * rayLength,
      );

      rays.add([
        start,
        end,
      ]);
    }
  }

  draw(CanvasRenderingContext2D ctx) {
    for (var i = 0; i < rayCount; i++) {
      var end = rays[i][1];

      if (readings[i] != null) {
        end = Point(
          x: readings[i].x,
          y: readings[i].y,
        );
      }

      ctx.beginPath();
      ctx.lineWidth = 2;
      ctx.strokeStyle = 'lime';

      ctx.moveTo(
        rays[i][0].x,
        rays[i][0].y,
      );

      ctx.lineTo(
        end.x,
        end.y,
      );

      ctx.stroke();

      ctx.beginPath();
      ctx.lineWidth = 2;
      ctx.strokeStyle = 'red';

      ctx.moveTo(
        rays[i][1].x,
        rays[i][1].y,
      );

      ctx.lineTo(
        end.x,
        end.y,
      );

      ctx.stroke();
    }
  }
}
