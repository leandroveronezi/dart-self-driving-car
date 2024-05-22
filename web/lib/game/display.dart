import 'dart:html';
import 'dart:math';

import '../classes/car.dart';
import '../classes/knife.dart';

class GameDisplay {
  CanvasRenderingContext2D ctx;

  int generation = 0;
  int bestScore = 0;
  int total = 0;
  int alive = 0;
  int traffic = 0;

  late Car bestCar;
  Knife knife;

  GameDisplay({
    required this.ctx,
    required this.knife,
  });

  draw() {
    ctx.beginPath();

    ctx.setLineDash([]);

    //
    ctx.textBaseline = "middle";
    ctx.fillStyle = "rgba(0,255,0,0.7)";
    ctx.strokeStyle = "black";
    ctx.font = "12px monospace";

    ctx.fillText("Generation: $generation", 5, 12);
    ctx.fillText("BS: $bestScore", ctx.canvas.width! - 100, 12);

    ctx.fillText("Total: $total", 5, 26);
    ctx.fillText("Alive: $alive", ctx.canvas.width! - 100, 26);

    ctx.beginPath();
    ctx.moveTo(5, 34);
    ctx.lineTo(ctx.canvas.width! - 2, 34);

    ctx.lineWidth = 1;
    ctx.strokeStyle = "white";
    ctx.stroke();

    ctx.fillText("ID: ${bestCar.id}", 5, 44);
    ctx.fillText("Angle: ${bestCar.angle.toStringAsFixed(2)}", 5, 58);
    ctx.fillText("Speed: ${bestCar.speed.toStringAsFixed(2)}", 5, 72);

    ctx.fillText("Score: ${bestCar.score}", ctx.canvas.width! - 100, 44);

    ctx.fillText("K. Speed: ${knife.speed.toStringAsFixed(2)}", 5, 86);
    ctx.fillText("K. distance : ${(knife.y - bestCar.y).toStringAsFixed(2)}", 5, 98);

    ctx.fillText("X: ${bestCar.x.toStringAsFixed(2)}", ctx.canvas.width! - 100, 58);
    ctx.fillText("Y: ${bestCar.y.toStringAsFixed(2)}", ctx.canvas.width! - 100, 72);

    ctx.fillText(
      "Traffic : $traffic",
      ctx.canvas.width! - 100,
      86,
    );

    drawProgressBar(
      ctx.canvas.width! - 100,
      98,
      calcularProgresso(knife.y - bestCar.y),
      width: 90,
      rotate: false,
      showText: false,
      barColor: "rgba(255, 0, 0, 0.6)",
    );

    if (bestCar.maxPenalty > 0) {
      double p = bestCar.penalty < 0 ? 0 : (bestCar.penalty * 100) / bestCar.maxPenalty;

      drawProgressBar(
        ctx.canvas.width! - 100,
        112,
        p,
        width: 90,
        rotate: false,
        showText: false,
        barColor: "rgba(255, 0, 0, 0.6)",
      );
    }
  }

  double calcularProgresso(double distancia) {
    distancia = distancia.abs();

    // Normaliza a distância para o intervalo [0, 1]
    double distanciaNormalizada = distancia / 2000; // Suponha que 2000 é a distância máxima
    // Calcula o progresso inversamente proporcional à distância
    double progresso = (1 - distanciaNormalizada) * 100;
    // Garante que o progresso esteja dentro do intervalo [0, 100]
    progresso = progresso.clamp(0, 100);

    return progresso;
  }

  drawProgressBar(
    double x,
    double y,
    double progress, {
    double height = 9,
    double width = 100,
    bool rotate = false,
    String barColor = "rgba(0, 255, 0, 0.8)",
    bool showText = true,
  }) {
    if (rotate) {
      var x1 = x;
      var y1 = y;

      x = y1;
      y = x1;

      var width1 = width;
      var height1 = height;

      width = height1;
      height = width1;
    } else {
      y = y - 5;
    }

    // Limpa o canvas
    ctx.clearRect(x, y, width, height);

    // Desenha o fundo da barra de progresso
    ctx.fillStyle = "#e0e0e0";
    ctx.fillRect(x, y, width, height);

    // Desenha a barra de progresso atual
    ctx.fillStyle = barColor;

    if (rotate) {
      var x1 = x;
      var y1 = y + height - (height * progress) / 100;
      var w1 = width;
      var h1 = height * progress / 100;

      ctx.fillRect(x1, y1, w1, h1);
    } else {
      ctx.fillRect(x, y, (width * progress) / 100, height);
    }

    if (showText) {
      // Desenha o texto de progresso
      ctx.fillStyle = "black";
      ctx.font = "8px monospace";
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";

      if (!rotate) {
        ctx.fillText("$progress%", x + width / 2, y + height / 2);
      } else {
        ctx.save(); // Salva o estado atual do contexto
        ctx.translate(x + width / 2, y + height / 2); // Translada para o centro da barra
        ctx.rotate(-pi / 2); // Rotaciona 90 graus no sentido horário
        ctx.fillText("$progress%", 0, 0); // Desenha o texto na posição (0, 0) do sistema de coordenadas rotacionado
        ctx.restore(); // Restaura o estado original do contexto
      }
    }
  }
}
