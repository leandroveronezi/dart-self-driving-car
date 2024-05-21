import 'dart:math';

import '../classes/car.dart';
import '../classes/controls.dart';
import '../classes/gameObject.dart';
import '../classes/policeOfficer.dart';
import '../classes/road.dart';
import '../classes/trafficCone.dart';
import '../classes/trafficEasel.dart';
import '../classes/trafficLanes.dart';
import 'imagesCar.dart';

class Combos {
  static List<GameObject> generateInitialBarrier(Road road, double y) {
    return [
      ...List.generate(
        road.laneCount,
        (index) => PoliceOfficer(
          x: road.getLaneCenter(index),
          y: y + 100,
          type: PoliceOfficerType.values[Random().nextInt(2)],
          angle: index < 2 ? -0.4 : 0.4,
        ),
      ),
      ...List.generate(
        road.laneCount,
        (index) => TrafficLane(
          x: road.getLaneCenter(index),
          y: y + 80,
          type: TrafficLanesType.yellowStrip,
        ),
      ),
      ...List.generate(
        road.laneCount,
        (index) => TrafficEasel(
          x: road.getLaneCenter(index),
          y: y + 60,
        ),
      ),
      ...List.generate(
        road.laneCount,
        (index) => Car(
          x: road.getLaneCenter(index),
          y: y + 160,
          maxSpeed: 0,
          carModel: CarModel.swatVan,
          controlType: CarControlTypes.static,
          drawLights: true,
          angle: index < 2 ? -0.4 : 0.4,
        ),
      ),
    ];
  }

  static List<GameObject> generateAccident1(Road road, double y) {
    var line = [0, road.laneCount - 2][Random().nextInt(2)];

    return [
      //!
      Car(
        x: [road.getLaneCenter(1), road.getLaneCenter(road.laneCount - 2)][line == 0 ? 0 : 1],
        y: y - 500,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      Car(
        x: [road.getLaneCenter(0), road.getLaneCenter(road.laneCount - 1)][line == 0 ? 1 : 0],
        y: y - 250,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      Car(
        x: [road.getLaneCenter(1), road.getLaneCenter(road.laneCount - 2)][line == 0 ? 1 : 0],
        y: y - 50,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      TrafficCone(
        x: [road.getLaneCenter(0) - 20, road.getLaneCenter(road.laneCount - 1) + 20][line == 0 ? 0 : 1],
        y: y - 520,
      ),
      TrafficCone(
        x: [road.getLaneCenter(0), road.getLaneCenter(road.laneCount - 1)][line == 0 ? 0 : 1],
        y: y - 480,
      ),
      TrafficCone(
        x: [road.getLaneCenter(0) + 20, road.getLaneCenter(road.laneCount - 1) - 20][line == 0 ? 0 : 1],
        y: y - 440,
      ),
      //
      TrafficCone(
        x: [road.getLaneCenter(1) - 20, road.getLaneCenter(road.laneCount - 2) + 20][line == 0 ? 0 : 1],
        y: y - 400,
      ),
      TrafficCone(
        x: [road.getLaneCenter(1), road.getLaneCenter(road.laneCount - 2)][line == 0 ? 0 : 1],
        y: y - 360,
      ),
      TrafficCone(
        x: [road.getLaneCenter(1) + 20, road.getLaneCenter(road.laneCount - 2) - 20][line == 0 ? 0 : 1],
        y: y - 320,
      ),
      Car(
        x: road.getLaneCenter(line) + 20,
        y: y - 300,
        maxSpeed: 0,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -0.7,
      ),
      Car(
        x: road.getLaneCenter(line) + 20,
        y: y - 200,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -0.7,
      )
        ..damageable = true
        ..damaged = true,
      Car(
        x: road.getLaneCenter(line + 1),
        y: y - 250,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: 0.4,
      )
        ..damageable = true
        ..damaged = true,
      Car(
        x: road.getLaneCenter(line + 1),
        y: y - 200,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
      )
        ..damageable = true
        ..damaged = true,
      Car(
        x: road.getLaneCenter(line + (1 * line)),
        y: y - 50,
        maxSpeed: 0,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: line == 0 ? -0.2 : 0.2,
      ),
      TrafficCone(
        x: [(road.getLaneCenter(1) - 20), road.getLaneCenter(road.laneCount - 2) + 20][line == 0 ? 0 : 1],
        y: y - 20,
      ),
      TrafficCone(
        x: [(road.getLaneCenter(1)), road.getLaneCenter(road.laneCount - 2)][line == 0 ? 0 : 1],
        y: y - 60,
      ),
      TrafficCone(
        x: [(road.getLaneCenter(1) + 20), road.getLaneCenter(road.laneCount - 2) - 20][line == 0 ? 0 : 1],
        y: y - 100,
      ),
      TrafficCone(
        x: [road.getLaneCenter(0) - 20, road.getLaneCenter(road.laneCount - 1) + 20][line == 0 ? 0 : 1],
        y: y + 100,
      ),
      TrafficCone(
        x: [road.getLaneCenter(0), road.getLaneCenter(road.laneCount - 1)][line == 0 ? 0 : 1],
        y: y + 60,
      ),
      TrafficCone(
        x: [road.getLaneCenter(0) + 20, road.getLaneCenter(road.laneCount - 1) - 20][line == 0 ? 0 : 1],
        y: y + 20,
      ),
    ];
  }

  static List<GameObject> generateAccident2(Road road, double y) {
    var aux = CarInfo.getRandomServiceCar();

    var line1 = road.getLaneCenter(1);
    var line2 = road.getLaneCenter(2);

    return [
      //!
      Car(
        x: road.getLaneCenter(0),
        y: y - 300,
        carModel: aux,
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      Car(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y - 300,
        carModel: aux,
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      TrafficCone(
        x: line1 + 20,
        y: y - 400,
      ),
      TrafficCone(
        x: line1,
        y: y - 360,
      ),
      TrafficCone(
        x: line1 - 20,
        y: y - 320,
      ),
      //
      TrafficCone(
        x: line2 - 20,
        y: y - 400,
      ),
      TrafficCone(
        x: line2,
        y: y - 360,
      ),
      TrafficCone(
        x: line2 + 20,
        y: y - 320,
      ),
      Car(
        x: line1 + 20,
        y: y - 290,
        maxSpeed: 0,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -0.7,
      ),
      Car(
        x: line1 + 20,
        y: y - 150,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -0.7,
      )
        ..damageable = true
        ..damaged = true,
      Car(
        x: line2,
        y: y - 200,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: 0.4,
      )
        ..damageable = true
        ..damaged = true,
      Car(
        x: line2,
        y: y - 150,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
      )
        ..damageable = true
        ..damaged = true,
      Car(
        x: line2 - 30,
        y: y - 30,
        maxSpeed: 0,
        carModel: [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)],
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -0.9,
      ),
      TrafficCone(
        x: line1 + 20,
        y: y + 100,
      ),
      TrafficCone(
        x: line1,
        y: y + 60,
      ),
      TrafficCone(
        x: line1 - 20,
        y: y + 20,
      ),
      TrafficCone(
        x: line2 - 20,
        y: y + 100,
      ),
      TrafficCone(
        x: line2,
        y: y + 60,
      ),
      TrafficCone(
        x: line2 + 20,
        y: y + 20,
      ),
    ];
  }

  static List<GameObject> generatePoliceBarrier1(Road road, double y) {
    var result = <GameObject>[];

    var models = [
      CarModel.specialAgentCar,
      CarModel.copCar,
      CarModel.swatVan,
    ];

    var model = models[Random().nextInt(models.length)];

    int totalNewCars = 1;

    do {
      totalNewCars = Random().nextInt(road.laneCount);
    } while (totalNewCars == 0);

    var usedLines = <int>{}; // Conjunto para rastrear linhas usadas

    for (var i = 0; i < totalNewCars; i++) {
      int line;

      do {
        line = Random().nextInt(road.laneCount);
      } while (usedLines.contains(line)); // Garante que a linha não foi usada

      usedLines.add(line);

      result.addAll(
        [
          Car(
            x: road.getLaneCenter(line),
            y: y,
            maxSpeed: 0,
            carModel: model,
            controlType: CarControlTypes.static,
            drawLights: true,
            angle: [-0.4, 0.4][Random().nextInt(2)],
          ),
          TrafficEasel(
            x: road.getLaneCenter(line),
            y: y + 60,
          ),
        ],
      );
    }

    return result;
  }

  static List<GameObject> generatePoliceBarrier2(Road road, double y) {
    return [
      Car(
        x: road.getLaneCenter(1),
        y: y - 50,
        carModel: CarInfo.getRandomMilitarCar(),
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      Car(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y - 250,
        carModel: CarInfo.getRandomMilitarCar(),
        controlType: CarControlTypes.dummy,
        drawLights: true,
      ),
      ...List.generate(
        road.laneCount,
        (index) => TrafficLane(
          x: road.getLaneCenter(index),
          y: y - 200,
          type: TrafficLanesType.yellowStrip,
        ),
      ),
      ...List.generate(
        road.laneCount,
        (index) => TrafficLane(
          x: road.getLaneCenter(index),
          y: y + 120,
          type: TrafficLanesType.yellowStrip,
        ),
      ),
      Car(
        x: road.getLaneCenter(0) - 8,
        y: y - 150,
        maxSpeed: 0,
        carModel: CarModel.armedLandRoamer,
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -2.7,
      ),
      Car(
        x: road.getLaneCenter(0) - 8,
        y: y - 50,
        maxSpeed: 0,
        carModel: CarModel.landRoamer,
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: -2.7,
      ),
      Car(
        x: road.getLaneCenter(road.laneCount - 1) + 8,
        y: y - 150,
        maxSpeed: 0,
        carModel: CarModel.tank,
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: 2.7,
      ),
      Car(
        x: road.getLaneCenter(road.laneCount - 1) + 8,
        y: y - 50,
        maxSpeed: 0,
        carModel: CarModel.pacifier,
        controlType: CarControlTypes.static,
        drawLights: true,
        angle: 2.7,
      ),
      TrafficCone(
        x: road.getLaneCenter(0) - 20,
        y: y + 100,
      ),
      TrafficCone(
        x: road.getLaneCenter(0),
        y: y + 60,
      ),
      TrafficCone(
        x: road.getLaneCenter(0) + 20,
        y: y + 20,
      ),
      TrafficCone(
        x: road.getLaneCenter(road.laneCount - 1) + 20,
        y: y + 100,
      ),
      TrafficCone(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y + 60,
      ),
      TrafficCone(
        x: road.getLaneCenter(road.laneCount - 1) - 20,
        y: y + 20,
      ),
    ];
  }

  static List<GameObject> generatePoliceBarrier3(Road road, double y) {
    int totalNewCars;

    do {
      totalNewCars = Random().nextInt(road.laneCount - 1);
    } while (totalNewCars == 0);

    return [
      ...List.generate(
        totalNewCars,
        (index) => Car(
          x: road.getLaneCenter(index),
          y: y - 50,
          carModel: CarInfo.getRandomCarModel(),
          controlType: CarControlTypes.dummy,
          maxSpeed: 2,
        ),
      ),
      PoliceOfficer(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y - 90,
        type: PoliceOfficerType.one,
        angle: -1.4,
      ),
      Car(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y - 200,
        maxSpeed: 0,
        carModel: CarInfo.getRandomCarModel(),
        controlType: CarControlTypes.static,
        drawLights: true,
      ),
      Car(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y - 50,
        maxSpeed: 0,
        carModel: CarModel.copCar,
        controlType: CarControlTypes.static,
        drawLights: true,
      ),
      TrafficCone(
        x: road.getLaneCenter(road.laneCount - 1) + 20,
        y: y + 100,
      ),
      TrafficCone(
        x: road.getLaneCenter(road.laneCount - 1),
        y: y + 60,
      ),
      TrafficCone(
        x: road.getLaneCenter(road.laneCount - 1) - 20,
        y: y + 20,
      ),
    ];
  }
}
