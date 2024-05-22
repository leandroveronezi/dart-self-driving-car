import 'dart:html';
import 'dart:math';

import '../utils/utils.dart';
import 'point.dart';

class Road {
  double x;
  double width;
  int laneCount;

  Road({
    required this.x,
    required this.width,
    required this.laneCount,
  });

  double get left => x - width / 2;
  double get right => x + width / 2;

  double get infinity => 1000000;
  double get top => -infinity;
  double get bottom => infinity;

  Point get topLeft => Point(x: left, y: top);
  Point get topRight => Point(x: right, y: top);
  Point get bottomLeft => Point(x: left, y: bottom);
  Point get bottomRight => Point(x: right, y: bottom);

  List<List<Point>> get borders => [
        [topLeft, bottomLeft],
        [topRight, bottomRight],
      ];

  double getLaneCenter(int lane) {
    double laneWidth = width / laneCount;

    return left + laneWidth / 2 + min(lane, laneCount - 1) * laneWidth;
  }

  draw(CanvasRenderingContext2D ctx) {
    ctx.lineWidth = 5;
    ctx.strokeStyle = 'white';

    for (int i = 1; i <= laneCount - 1; i++) {
      var x = lerpDouble(left, right, i / laneCount);

      ctx.setLineDash([20, 20]);

      ctx.beginPath();
      ctx.moveTo(x, top);
      ctx.lineTo(x, bottom);
      ctx.stroke();
    }

    ctx.setLineDash([]);

    for (var border in borders) {
      ctx.strokeStyle = 'yellow';
      ctx.beginPath();
      ctx.moveTo(border[0].x, border[0].y);
      ctx.lineTo(border[1].x, border[1].y);
      ctx.stroke();
    }
  }
}
