import 'dart:html';
import 'dart:math';

import '../classes/point.dart';
import 'imagesCar.dart';

double lerpDouble(double a, double b, double t) => a + (b - a) * t;

getIntersection(Point A, Point B, Point C, Point D) {
  final tTop = (D.x - C.x) * (A.y - C.y) - (D.y - C.y) * (A.x - C.x);
  final uTop = (C.y - A.y) * (A.x - B.x) - (C.x - A.x) * (A.y - B.y);
  final bottom = (D.y - C.y) * (B.x - A.x) - (D.x - C.x) * (B.y - A.y);

  if (bottom != 0) {
    final t = tTop / bottom;
    final u = uTop / bottom;

    if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {
      return (
        x: lerpDouble(A.x, B.x, t),
        y: lerpDouble(A.y, B.y, t),
        offset: t,
      );
    }
  }

  return null;
}

polyIntersect(List<Point> poly1, List<Point> poly2) {
  for (var i = 0; i < poly1.length; i++) {
    for (var j = 0; j < poly2.length; j++) {
      var touch = getIntersection(
        poly1[i],
        poly1[(i + 1) % poly1.length],
        poly2[j],
        poly2[(j + 1) % poly2.length],
      );

      if (touch != null) {
        return true;
      }
    }
  }
  return false;
}

getRGBA(double value) {
  var alpha = value.abs();

  var R = value < 0 ? 0 : 255;
  var G = R;
  var B = value > 0 ? 0 : 255;

  return "rgba($R,$G,$B,$alpha)";
}

getRandomColor() {
  final hue = 290 + Random().nextDouble() * 260;

  return "hsl($hue, 100%, 60%)";
}

extension ExDouble on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension ExRandom on Random {
  double nextGaussian() {
    Random random = Random();

    // Gera dois números aleatórios uniformes
    double u1 = random.nextDouble();
    double u2 = random.nextDouble();

    // Calcula o número aleatório com distribuição normal
    double z = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
    return z;
  }
}

createMask(width, height, String imgPath, CanvasElement canvas) {
  //! load image
  var img = document.createElement("img") as ImageElement;

  img.src = imgPath;

  final maskCtx = canvas.getContext("2d") as CanvasRenderingContext2D;

  img.onLoad.listen(
    (event) {
      maskCtx.fillStyle = "rgba(0, 0, 0, 0)";

      maskCtx.rect(0, 0, width, height);
      maskCtx.fill();

      maskCtx.globalCompositeOperation = "destination-atop";

      maskCtx.drawImageToRect(
        img,
        Rectangle(
          0,
          0,
          width,
          height,
        ),
      );
    },
  );
}

double calcularValorLinear(int i, int minI, int maxI, double minX, double maxX) {
  // Calcular o ponto médio
  double midI = (maxI + minI) / 2;

  // Função linear de incremento até o meio
  if (i <= midI) {
    return minX + ((maxX - minX) / midI) * i;
  }
  // Função linear de decremento após o meio
  else {
    return maxX - ((maxX - minX) / (maxI - midI)) * (i - midI);
  }
}
