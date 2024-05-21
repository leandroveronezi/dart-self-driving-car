import 'dart:html';
import 'dart:math';

import '../utils/utils.dart';
import 'point.dart';

abstract class GameObject {
  //
  late int width;
  late int height;
  double x;
  double y;
  double angle = 0;
  List<Point> polygon = [];

  bool _damaged = false;
  bool damageable = true;
  bool solid;

  GameObject({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.angle = 0,
    this.solid = true,
  }) {
    //
  }

  void move();
  void draw(CanvasRenderingContext2D ctx);
  void dispose();

  bool get damaged => _damaged;

  set damaged(bool value) {
    if (damageable) {
      _damaged = value;
    }
  }

  update(List<List<Point>> roadBorders, List<GameObject> traffic) {
    if (damageable) {
      damaged = _assessDamage(roadBorders, traffic);
    }

    polygon = createPolygon();
  }

  bool _assessDamage(List<List<Point>> roadBorders, List<GameObject> traffic) {
    for (var i = 0; i < roadBorders.length; i++) {
      var border = roadBorders[i];
      if (polyIntersect(polygon, border)) {
        return true;
      }
    }

    for (var i = 0; i < traffic.length; i++) {
      if (polyIntersect(polygon, traffic[i].polygon)) {
        return true;
      }
    }

    return false;
  }

  List<Point> createPolygon() {
    if (!solid) {
      return [];
    }

    List<Point> points = [];

    var rad = sqrt(width * width + height * height) / 2;
    var alpha = atan2(width, height);

    points.add(
      Point(
        x: x - sin(angle - alpha) * rad,
        y: y - cos(angle - alpha) * rad,
      ),
    );

    points.add(
      Point(
        x: x - sin(angle + alpha) * rad,
        y: y - cos(angle + alpha) * rad,
      ),
    );

    points.add(
      Point(
        x: x - sin(pi + angle - alpha) * rad,
        y: y - cos(pi + angle - alpha) * rad,
      ),
    );

    points.add(
      Point(
        x: x - sin(pi + angle + alpha) * rad,
        y: y - cos(pi + angle + alpha) * rad,
      ),
    );

    return points;
  }
}
