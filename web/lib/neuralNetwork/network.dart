import 'dart:math';

import '../utils/utils.dart';

enum FuncaoAtivacao {
  sigmoid,
  tanh,
  relu,
}

class NeuralNetwork {
  List<Layer> layers = [];
  List<double> inputs = [];

  FuncaoAtivacao funcaoAtivacao = FuncaoAtivacao.relu;

  NeuralNetwork({
    required this.layers,
    this.funcaoAtivacao = FuncaoAtivacao.relu,
  });

  static NeuralNetwork fromStructure(List<int> networkStructure, {funcaoAtivacao = FuncaoAtivacao.relu}) {
    //
    List<Layer> auxLayers = [];

    for (var i = 1; i < networkStructure.length; i++) {
      auxLayers.add(
        Layer(
          neurons: List.generate(
            networkStructure[i],
            (index) => Neuron(
              weights: List.generate(
                networkStructure[i - 1],
                (index) => Random().nextGaussian() * 2 - 1,
              ),
              bias: Random().nextGaussian() * 2 - 1,
            ),
          ),
        ),
      );
    }

    return NeuralNetwork(
      layers: auxLayers,
      funcaoAtivacao: funcaoAtivacao,
    );
  }

  List<double> forward(List<double> inputs) {
    this.inputs = inputs;

    var current = inputs;

    for (var i = 0; i < layers.length; i++) {
      current = layers[i].forward(current, funcaoAtivacao);
    }

    return current;
  }

  void mutateRandom({
    double layoutMutationRate = 1,
    double neuronMutationRate = 1,
    double mutationWeightsRate = 0.1,
    double mutationBiasRate = 0.1,
  }) {
    for (var layer in layers) {
      if (Random().nextDouble() >= layoutMutationRate) {
        print(1);
        continue;
      }

      for (var neuron in layer.neurons) {
        if (Random().nextDouble() >= neuronMutationRate) {
          print(2);
          continue;
        }

        for (var i = 0; i < neuron.weights.length; i++) {
          if (Random().nextDouble() < mutationWeightsRate) {
            print(3);
            neuron.weights[i] += Random().nextGaussian() * 0.2 - 0.1; // Adjust weights by a random value in range [-0.1, 0.1]
          }
        }
        if (Random().nextDouble() < mutationBiasRate) {
          print(4);
          neuron.bias += Random().nextGaussian() * 0.2 - 0.1; // Adjust bias by a random value in range [-0.1, 0.1]
        }
      }
    }
  }

  void mutateLerp({
    double layoutMutationRate = 1,
    double neuronMutationRate = 1,
    double mutationWeightsRate = 0.1,
    double mutationBiasRate = 0.1,
    double amount = 1,
  }) {
    for (var layer in layers) {
      if (Random().nextDouble() >= layoutMutationRate) {
        continue;
      }

      for (var neuron in layer.neurons) {
        if (Random().nextDouble() >= neuronMutationRate) {
          continue;
        }

        for (var i = 0; i < neuron.weights.length; i++) {
          if (Random().nextDouble() < mutationWeightsRate) {
            neuron.weights[i] = lerpDouble(neuron.weights[i], Random().nextGaussian() * 2 - 1, amount);
          }
        }
        if (Random().nextDouble() < mutationBiasRate) {
          neuron.bias = lerpDouble(neuron.bias, Random().nextGaussian() * 2 - 1, amount);
        }
      }
    }
  }

  double evaluate(List<double> inputs, List<double> expectedOutputs) {
    List<double> outputs = forward(inputs);
    double error = 0.0;
    for (int i = 0; i < outputs.length; i++) {
      error += pow(outputs[i] - expectedOutputs[i], 2);
    }
    return error;
  }

  Map<String, dynamic> toMap() {
    return {
      'layers': layers.map((layer) => layer.toMap()).toList(),
      'funcaoAtivacao': funcaoAtivacao.name,
    };
  }

  static NeuralNetwork fromMap(Map<String, dynamic> json) {
    var layers = (json['layers'] as List<dynamic>).map((layerJson) => Layer.fromMap(layerJson)).toList();
    return NeuralNetwork(
      layers: layers,
      funcaoAtivacao: FuncaoAtivacao.values.byName(json['funcaoAtivacao'] as String),
    );
  }
}

class Layer {
  //
  List<Neuron> neurons = [];

  Layer({
    required this.neurons,
  });

  // Inicialização de pesos com Xavier: Use Xavier com funções de ativação sigmoid ou tanh.
  static void initializeWeightsXavier(List<Neuron> neurons) {
    for (var neuron in neurons) {
      for (var i = 0; i < neuron.weights.length; i++) {
        // Inicializa usando a distribuição normal (média 0 e variância 1)
        neuron.weights[i] = Random().nextGaussian() * sqrt(2 / (neuron.weights.length + 1));
      }
    }
  }

  // Inicialização de pesos com He: Use He com a função de ativação ReLU.
  static void initializeWeightsHe(List<Neuron> neurons) {
    for (var neuron in neurons) {
      for (var i = 0; i < neuron.weights.length; i++) {
        // Inicializa usando a distribuição normal (média 0 e variância 1)
        neuron.weights[i] = Random().nextGaussian() * sqrt(2 / neuron.weights.length);
      }
    }
  }

  List<double> forward(List<double> inputs, FuncaoAtivacao funcaoAtivacao) {
    return [
      for (var neuron in neurons) neuron.forward(inputs, funcaoAtivacao),
    ];
  }

  Map<String, dynamic> toMap() {
    return {
      'neurons': neurons.map((neuron) => neuron.toMap()).toList(),
    };
  }

  static Layer fromMap(Map<String, dynamic> json) {
    var neurons = (json['neurons'] as List<dynamic>).map((neuronJson) => Neuron.fromMap(neuronJson)).toList();

    return Layer(neurons: neurons);
  }
}

class Neuron {
  //pesos
  List<double> weights = [];
  //vies
  double bias = 0;
  double output = 0;

  Neuron({
    required this.weights,
    required this.bias,
  });

  double sigmoid(double x) {
    return 1 / (1 + exp(-x));
  }

  double tanh(double x) {
    return (exp(x) - exp(-x)) / (exp(x) + exp(-x));
  }

  double relu(double x) {
    return max(0, x);
  }

  double forward(List<double> inputs, FuncaoAtivacao funcaoAtivacao) {
    assert(inputs.length == weights.length);

    var sum = 0.0;

    for (var i = 0; i < inputs.length; i++) {
      sum += inputs[i] * weights[i];
    }

    switch (funcaoAtivacao) {
      case FuncaoAtivacao.sigmoid:
        sum += bias;
        output = sigmoid(sum);
        output = output > bias ? 1 : 0;
        break;
      case FuncaoAtivacao.tanh:
        sum += bias;
        output = tanh(sum);
        output = output > bias ? 1 : 0;
        break;
      case FuncaoAtivacao.relu:
        output = relu(sum);
        output = output > bias ? 1 : 0;
        break;
    }

    return output;
  }

  Map<String, dynamic> toMap() {
    return {
      'weights': weights.map((w) => w.toDouble()).toList(),
      'bias': bias,
    };
  }

  static Neuron fromMap(Map<String, dynamic> json) {
    var aux = json['weights'] == null ? [] : json['weights'] as List<dynamic>;

    return Neuron(
      weights: List.generate(aux.length, (index) => aux[index].toDouble()),
      bias: json['bias'].toDouble(),
    );
  }
}
