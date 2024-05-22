import 'dart:async';
import 'dart:html';
import 'dart:math';

import '../classes/car.dart';
import '../classes/controls.dart';
import '../classes/gameObject.dart';
import '../classes/graffit.dart';
import '../classes/knife.dart';
import '../classes/road.dart';
import '../classes/trafficLanes.dart';
import '../neuralNetwork/network.dart';
import '../neuralNetwork/visualizer.dart';
import '../utils/combos.dart';
import '../utils/imagesCar.dart';
import 'display.dart';
import 'storage.dart';

enum GameType {
  key,
  trainer,
}

const double yInitial = 900000;
const double knifeGameMaxSpeed = 2.0;
const int trainTotalCars = 50;
const int trainMaxPenalty = 250;

class Game {
  GameType gameType;
  bool trafficGenerateSpecialsItens;
  int roadLane;

  late Road road;
  late Storage storage;

  final List<GameObject> _trafficItens = [];
  final List<Car> _gameCars = [];

  late Car _carWithBestScore;
  late Car _carWithWorstScore;

  late Knife _knifeGame; //* barreira móvel para penalizar o jogador se o carro ficar parado ou andar a baixa velocidade
  late Knife _knifeTraffic; //* responsável por remover os carros do jogo apos serem ultrapassados

  late GameDisplay _display;

  late CanvasElement _roadCanvas;
  late CanvasRenderingContext2D _roadCtx;

  late CanvasElement _displayCanvas;
  late CanvasRenderingContext2D _displayCtx;

  late CanvasElement _netWorkCanvas;
  late CanvasRenderingContext2D _netWorkCtx;

  //!
  int _generation = 0;

  Game({
    this.gameType = GameType.key,
    this.trafficGenerateSpecialsItens = false,
    this.roadLane = 3,
  }) {
    //

    _displayCanvas = document.getElementById("displayCanvas") as CanvasElement;
    _displayCanvas.height = 125;
    _displayCanvas.width = 350;

    _netWorkCanvas = document.getElementById("netWorkCanvas") as CanvasElement;
    _netWorkCanvas.height = (window.innerHeight ?? 0) - (_displayCanvas.height ?? 0);
    _netWorkCanvas.width = _displayCanvas.width;

    _netWorkCtx = _netWorkCanvas.getContext("2d") as CanvasRenderingContext2D;

    _roadCanvas = document.getElementById("roadCanvas") as CanvasElement;
    _roadCanvas.height = window.innerHeight;
    _roadCanvas.width = (66.75 * roadLane).round();

    _roadCtx = _roadCanvas.getContext("2d") as CanvasRenderingContext2D;

    storage = Storage();

    if (storage.load() == false) {
      var preTreinedBrain = storage.preTrainedBrain();

      storage.generation = preTreinedBrain.$1;
      storage.score = preTreinedBrain.$2;
      storage.brain = preTreinedBrain.$3;
    } else {
      if (gameType == GameType.trainer) {
        _generation = storage.generation;
      }
    }

    road = Road(
      x: (_roadCanvas.width ?? 1) / 2,
      width: (_roadCanvas.width ?? 1) * 0.9,
      laneCount: roadLane,
    );

    _knifeGame = Knife(
      x: road.x,
      y: yInitial + 1000,
      width: road.right.toInt(),
      maxSpeed: knifeGameMaxSpeed,
    );

    _knifeTraffic = Knife(
      x: road.x,
      y: yInitial + 1000,
      width: road.right.toInt(),
      maxSpeed: 0,
    );

    _display = GameDisplay(
      ctx: _displayCanvas.getContext("2d") as CanvasRenderingContext2D,
      knife: _knifeGame,
    );

    _display.total = _gameCars.length;
    _display.alive = _gameCars.length;
    _display.generation = _generation;
    _display.bestScore = gameType == GameType.trainer ? storage.score : 0;

    //
    init();
  }

  init() {
    _knifeGame.y = yInitial + 1000;
    _knifeGame.maxSpeed = knifeGameMaxSpeed;

    _knifeTraffic.y = yInitial + 1000;

    for (var element in _gameCars) {
      element.dispose();
    }

    _gameCars.clear();

    if (gameType == GameType.key) {
      _gameCars.add(
        Car(
          id: 0,
          x: road.getLaneCenter(1),
          y: yInitial,
          carModel: CarModel.copCar,
          maxSpeed: 3,
          controlType: CarControlTypes.keys,
        ),
      );
    } else if (gameType == GameType.trainer) {
      _generation += 1;

      _gameCars.addAll([
        ...List.generate(
          trainTotalCars,
          (index) => Car(
            id: index,
            x: road.getLaneCenter(1),
            y: yInitial,
            controlType: CarControlTypes.ai,
            carModel: CarModel.copCar,
            maxPenalty: trainMaxPenalty,
            brain: storage.brain.isEmpty ? null : NeuralNetwork.fromMap(storage.brain),
          ),
        ),
      ]);
    }

    _mutateCars();

    _carWithBestScore = _gameCars[0];
    _carWithWorstScore = _gameCars[0];

    _display.traffic = _trafficItens.length;
    _display.generation = _generation;
    _display.total = _gameCars.length;
    _display.alive = _countCarsAlive();
    _display.bestCar = _carWithBestScore;
    _display.bestScore = gameType == GameType.trainer ? storage.score : 0;

    _generateInitialTraffic();
  }

  _mutateCars() {
    if (gameType == GameType.key || storage.brain.isEmpty) {
      return;
    }

    for (var i = 0; i < _gameCars.length; i++) {
      _gameCars[i].brain = NeuralNetwork.fromMap(storage.brain);

      if (i == 0) {
        continue;
      }

      //_gameCars[i].brain!.mutateRandom(layoutMutationRate: 1, neuronMutationRate: 1, mutationWeightsRate: 0.3, mutationBiasRate: 0.3);

      _gameCars[i].brain?.mutateLerp(
            layoutMutationRate: 1,
            neuronMutationRate: 0.8,
            mutationWeightsRate: 0.3,
            mutationBiasRate: 0.3,
            amount: 0.1,
          );
    }
  }

  _generateInitialTraffic() {
    for (var element in _trafficItens) {
      element.dispose();
    }

    _trafficItens.clear();

    var controlType = CarControlTypes.dummy;

    _trafficItens.addAll([
      Car(x: road.getLaneCenter(2), y: yInitial - 200, carModel: CarInfo.getRandomCarModel(), controlType: controlType),
      Car(x: road.getLaneCenter(1), y: yInitial - 450, carModel: CarInfo.getRandomCarModel(), controlType: controlType),
      Car(x: road.getLaneCenter(2), y: yInitial - 700, carModel: CarInfo.getRandomCarModel(), controlType: controlType),
      Car(x: road.getLaneCenter(1), y: yInitial - 950, carModel: CarInfo.getRandomCarModel(), controlType: controlType),
      ...Combos.generateInitialBarrier(road, yInitial),
    ]);
  }

  void _normalizeTrafficItens() {
    //sort all TrafficLane and GraffitiArt in fist in the list
    _trafficItens.sort(
      (a, b) => (a is TrafficLane || a is GraffitiArt) ? -1 : 1,
    );
  }

  void _addNewItensToTraffic(double y) {
    var roulette = Random().nextInt(100);

    if (trafficGenerateSpecialsItens && roulette >= 85) {
      _trafficItens.addAll(
        [
          Combos.generatePoliceBarrier1,
          Combos.generatePoliceBarrier2,
          Combos.generatePoliceBarrier3,
          Combos.generateAccident1,
          Combos.generateAccident2,
        ][Random().nextInt(5)](
          road,
          y,
        ),
      );

      _normalizeTrafficItens();

      return;
    } else if (roulette >= 80 && roulette < 85) {
      _trafficItens.add(
        GraffitiArt(
          x: road.getLaneCenter(Random().nextInt(road.laneCount)),
          y: y,
          type: GraffitiArt.getRandomGraffitiArt(),
        ),
      );

      _normalizeTrafficItens();
    } else if (roulette >= 75 && roulette < 80) {
      _trafficItens.addAll(
        List.generate(
          road.laneCount,
          (index) => TrafficLane(
            x: road.getLaneCenter(index),
            y: y,
            type: TrafficLanesType.crossWalk,
          ),
        ),
      );

      _normalizeTrafficItens();
    }

    int totalNewCars;

    do {
      totalNewCars = Random().nextInt(road.laneCount);
    } while (totalNewCars <= 0);

    var usedLines = <int>{}; // Conjunto para rastrear linhas usadas

    for (var i = 0; i < totalNewCars; i++) {
      int line;

      do {
        line = Random().nextInt(road.laneCount);
      } while (usedLines.contains(line)); // Garante que a linha não foi usada

      usedLines.add(line);

      _trafficItens.add(
        Car(
          x: road.getLaneCenter(line),
          y: y,
          carModel: CarInfo.getRandomCarModel(),
          controlType: CarControlTypes.dummy,
          maxSpeed: 2,
        ),
      );
    }
  }

  int _countCarsAlive() {
    return _gameCars.where((e) => !e.damaged).length;
  }

  void _updateControlCars() {
    if (_gameCars.isEmpty) {
      return;
    }

    if (_gameCars.length == 1) {
      _carWithBestScore = _gameCars.first;
      _carWithWorstScore = _gameCars.first;
      return;
    }

    var aux = _gameCars.where((e) => !e.damaged);

    if (aux.isNotEmpty) {
      _carWithBestScore = aux.reduce((c1, c2) => c1.score > c2.score ? c1 : c2);
    } else {
      _carWithBestScore = _gameCars.reduce((c1, c2) => c1.score > c2.score ? c1 : c2);
    }

    aux = _gameCars.where((e) => !e.damaged);

    if (aux.isNotEmpty) {
      _carWithWorstScore = aux.reduce((c1, c2) => c1.score < c2.score ? c1 : c2);
    } else {
      _carWithWorstScore = _gameCars.reduce((c1, c2) => c1.score < c2.score ? c1 : c2);
    }
  }

  void _updateKnifes() {
    //! update burn line
    _knifeGame.update([], []);
    _knifeTraffic.update([], []);

    if (_knifeGame.y - _carWithBestScore.y > 2000) {
      _knifeGame.y = _carWithBestScore.y + 2000;
    }

    if (_knifeTraffic.y - _carWithWorstScore.y > 500) {
      _knifeTraffic.y = _carWithWorstScore.y + 500;
    }
  }

  animate(time) {
    if (_countCarsAlive() == 0) {
      _updateControlCars();

      print("Generation: $_generation | Score: ${_carWithBestScore.score}");

      //! game over
      //! restart

      Timer(Duration(seconds: 2), () {
        init();
        animate(0);
      });
      return;
    }

    //! clean canvas
    _roadCanvas.height = window.innerHeight;
    _displayCanvas.height = _displayCanvas.height;
    _netWorkCanvas.height = (window.innerHeight ?? 0) - (_displayCanvas.height ?? 0);

    for (var car in _gameCars) {
      //
      if (car.damaged) {
        continue;
      }

      car.update(
        road.borders,
        _trafficItens,
      );

      if (car.y > _knifeGame.y) {
        car.damaged = true;
      }
    }

    for (var car in _trafficItens) {
      if (car.damaged) {
        continue;
      }

      //! new list from traffic without the current car and add myCar
      var newTraffic = _trafficItens.where((c) => c != car).toList();
      newTraffic.add(_carWithBestScore);

      car.update(
        road.borders,
        gameType == GameType.trainer ? [] : newTraffic,
      );

      if (car.y > _knifeTraffic.y) {
        car.damaged = true;

        Timer(Duration(milliseconds: 200), () {
          car.dispose();
          _trafficItens.remove(car);
        });
      }
    }

    _updateControlCars();
    _updateKnifes();

    //! draw on canvas
    //! block car camera
    _roadCtx.save();
    _roadCtx.translate(0, -_carWithBestScore.y + (_roadCanvas.height ?? 0) * 0.7);

    //! Condição para adicionar novos carros ao tráfego

    // A posição y do topo do canvas no sistema de coordenadas do melhor carro
    double y1 = _trafficItens.whereType<Car>().reduce((c1, c2) => c1.y < c2.y ? c1 : c2).y;
    double y2 = _carWithBestScore.y - 600;

    if (y1 > y2) {
      _addNewItensToTraffic(y1 - 250);
    }

    road.draw(_roadCtx);
    _knifeGame.draw(_roadCtx);

    //! draw cars with opacity
    _roadCtx.globalAlpha = 0.2;

    //! draw cars with opacity
    _roadCtx.globalAlpha = 0.2;
    for (var car in _gameCars) {
      car.draw(_roadCtx);
    }

    //! draw the best car without opacity
    _roadCtx.globalAlpha = 1;

    for (var i = 0; i < _trafficItens.length; i++) {
      _trafficItens[i].draw(
        _roadCtx,
      );
    }

    _carWithBestScore.drawSensors = _carWithBestScore.controlType == CarControlTypes.ai;

    _carWithBestScore.draw(
      _roadCtx,
    );

    _carWithBestScore.drawSensors = false;

    _roadCtx.restore();

    //! update placar
    _display.traffic = _trafficItens.length;
    _display.generation = _generation;
    _display.total = _gameCars.length;
    _display.alive = _countCarsAlive();
    _display.bestCar = _carWithBestScore;

    _display.draw();

    if (_carWithBestScore.brain != null) {
      Visualizer.drawNetwork(
        _netWorkCtx,
        _carWithBestScore.brain!,
        ['⬆', '⬅', '➡', '⬇'],
      );
    }

    if (gameType == GameType.trainer && _carWithBestScore.score > storage.score) {
      storage.generation = _generation;
      storage.score = _carWithBestScore.score;
      storage.brain = _carWithBestScore.brain!.toMap();
      storage.save();

      _display.bestScore = storage.score;
    }

    //! animate
    window.requestAnimationFrame(animate);
  }
}
