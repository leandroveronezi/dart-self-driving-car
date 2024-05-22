import 'dart:html';
import 'dart:math';

import 'network.dart';

class Visualizer {
  static void drawNetwork(CanvasRenderingContext2D ctx, NeuralNetwork network, List<String> outputLabels) {
    const margin = 25;
    const left = margin;
    const top = margin;
    final width = ctx.canvas.width! - margin * 2;
    final height = ctx.canvas.height! - margin * 2;

    final levelHeight = height / network.layers.length;

    for (var i = network.layers.length - 1; i >= 0; i--) {
      final levelTop = top + lerp(height - levelHeight, 0, network.layers.length == 1 ? 0.5 : i / (network.layers.length - 1));

      ctx.setLineDash([7, 3]);

      drawLayer(
        ctx,
        network.layers[i],
        left,
        levelTop,
        width,
        levelHeight,
        i == network.layers.length - 1 ? outputLabels : [],
        i == 0 ? network.inputs : [],
      );
    }
  }

  static void drawLayer(
    CanvasRenderingContext2D ctx,
    Layer layer,
    num left,
    num top,
    num width,
    num height,
    List<String> outputLabels,
    List<double> inputs,
  ) {
    final right = left + width;
    final bottom = top + height;

    final neuronsIndices = List.generate(layer.neurons.length, (index) => index);

    //! desenha as conexões
    var aux = inputs.isNotEmpty ? inputs : layer.neurons[0].weights;

    for (var i = 0; i < aux.length; i++) {
      for (var j = 0; j < layer.neurons.length; j++) {
        ctx.beginPath();

        ctx.moveTo(getNodeX(aux, i, left, right), bottom);
        ctx.lineTo(getNodeX(neuronsIndices, j, left, right), top);

        ctx.lineWidth = 2;
        ctx.strokeStyle = getRGBA(layer.neurons[j].weights[i]);
        ctx.stroke();
      }
    }

    final nodeRadius = 18;

    //! desenha os nodos de entrada
    for (var i = 0; i < inputs.length; i++) {
      final x = getNodeX(inputs, i, left, right);

      //! desenha o circulo maior para apagar o anterior e o circulo interno
      ctx.beginPath();
      ctx.arc(x, bottom, nodeRadius * 0.4, 0, 2 * pi);
      ctx.fillStyle = "black";
      ctx.fill();
      ctx.beginPath();
      ctx.arc(x, bottom, nodeRadius * 0.2, 0, 2 * pi);
      ctx.fillStyle = getRGBA(inputs[i]); // Usamos apenas o primeiro peso para a cor
      ctx.fill();

      //! desenha o circulo externo
      ctx.beginPath();
      ctx.lineWidth = 2;
      ctx.arc(x, bottom, nodeRadius * 0.4, 0, 2 * pi);
      ctx.strokeStyle = "white";
      ctx.setLineDash([3, 3]);
      ctx.stroke();
      ctx.setLineDash([]);
    }

    //! desenha os nodos de saida
    for (var i = 0; i < layer.neurons.length; i++) {
      //! desenha o circulo maior para apagar o anterior e o circulo interno
      final x = getNodeX(neuronsIndices, i, left, right);
      ctx.beginPath();
      ctx.arc(x, top, nodeRadius, 0, 2 * pi);
      ctx.fillStyle = "black";
      ctx.fill();
      ctx.beginPath();
      ctx.arc(x, top, nodeRadius * 0.6, 0, 2 * pi);
      ctx.fillStyle = getRGBA(layer.neurons[i].output);

      ctx.fill();

      //! desenha o circulo externo
      ctx.beginPath();
      ctx.lineWidth = 2;
      ctx.arc(x, top, nodeRadius * 0.8, 0, 2 * pi);
      ctx.strokeStyle = getRGBA(layer.neurons[i].bias);

      ctx.setLineDash([3, 3]);
      ctx.stroke();
      ctx.setLineDash([]);

      //! escreve o texto no meio
      ctx.beginPath();
      ctx.textAlign = "center";
      ctx.textBaseline = "middle";
      ctx.fillStyle = "black";
      ctx.strokeStyle = "white";
      ctx.font = "${nodeRadius * 1.5}px Arial";

      if (i < outputLabels.length) {
        //! escreve o texto
        ctx.fillText(outputLabels[i], x, top + nodeRadius * 0.1);

        //! escreve o texto no meio
        ctx.lineWidth = 0.5;
        ctx.strokeText(outputLabels[i], x, top + nodeRadius * 0.1);
      }
    }
  }

  static num getNodeX(List<dynamic> nodes, int index, num left, num right) {
    return lerp(left, right, nodes.length == 1 ? 0.5 : index / (nodes.length - 1));
  }

  static num lerp(num a, num b, num t) {
    return a + (b - a) * t;
  }

  static String getRGBA(double value) {
    final alpha = value.abs();

    final R = value < 0 ? 0 : 255;
    final G = R;
    final B = value > 0 ? 0 : 255;

    return "rgba($R ,$G,$B,$alpha)";
  }
}
