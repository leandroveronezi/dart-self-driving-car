import 'dart:html';
import 'dart:math';

import '../game/game.dart';
import '../neuralNetwork/network.dart';
import '../utils/imagesCar.dart';
import '../utils/utils.dart';
import 'controls.dart';
import 'gameObject.dart';
import 'point.dart';
import 'sensor.dart';

class Car extends GameObject {
  int id = -1;

  double speed;
  double acceleration;
  double maxSpeed;
  double friction;
  int penalty;
  int maxPenalty;

  late Controls controls;
  Sensor? sensor;
  NeuralNetwork? brain;
  CarControlTypes controlType = CarControlTypes.dummy;
  CanvasElement? mask;
  CanvasElement? maskDamage;
  CarModel carModel;
  int tick = 0;

  bool drawSensors;
  bool drawLights;

  Car({
    this.id = 0,
    this.acceleration = 0.2,
    this.maxSpeed = 3,
    this.speed = 0,
    this.friction = 0.05,
    this.penalty = 0,
    this.maxPenalty = 0,
    required super.x,
    required super.y,
    super.height = 5,
    super.width = 0,
    super.angle = 0,
    this.controlType = CarControlTypes.dummy,
    this.carModel = CarModel.copCar,
    this.brain,
    this.drawSensors = false,
    this.drawLights = false,
  }) {
    //

    var size = (carModel.getInfo()['type'] as CarType).gerSize();

    height = size['height'];
    width = size['width'];

    mask = document.createElement("canvas") as CanvasElement;
    mask!.width = width;
    mask!.height = height;

    createMask(width, height, carModel.getInfo()['image'], mask!);

    maskDamage = document.createElement("canvas") as CanvasElement;
    maskDamage!.width = width;
    maskDamage!.height = height;

    createMask(width, height, carModel.getInfo()['imageDamage'] ?? DamageImages.damaged1, maskDamage!);

    controls = Controls(
      controlType: controlType,
    );

    if (controlType == CarControlTypes.static) {
      maxSpeed = 0;
      damageable = false;
    } else if (controlType == CarControlTypes.dummy) {
      maxSpeed = 1;
      //drawSensors = true;

      //max speed range [1 ... 2.4];
      //maxSpeed = max(0.8, Random().nextDouble() * 1.2);

      sensor = Sensor(
        rayCount: 7,
        rayLength: 150,
        raySpread: pi * 0.35,
      );
    } else if (controlType == CarControlTypes.keys) {
      sensor = Sensor(
        rayCount: 5,
        rayLength: 100,
      );
    } else if (controlType == CarControlTypes.ai) {
      sensor = Sensor(
        rayCount: 9,
        rayLength: 200,
        raySpread: pi / 2,
      );

      var primeira = sensor?.rayCount ?? 0;

      var ultima = 4;

      var segunda = (primeira + ultima) ~/ 2;
      //var segunda = (primeira) * (2 ~/ 3) + ultima;

      brain = brain ??
          (brain = NeuralNetwork.fromStructure(
            [
              primeira,
              segunda,
              //terceira,
              ultima,
            ],
            funcaoAtivacao: FuncaoAtivacao.relu,
          ));
    }
  }

  int get score => (yInitial - y).toInt();

  @override
  void draw(CanvasRenderingContext2D ctx) {
    if (drawSensors) {
      try {
        sensor?.draw(ctx);
      } catch (e) {
        //
      }
    }

    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(-angle);

    ctx.drawImageToRect(
      damaged ? maskDamage! : mask!,
      Rectangle(
        -width / 2,
        -height / 2,
        width,
        height,
      ),
    );

    if (!damaged && drawLights) {
      tick += 1;

      var lights = carModel.gerLights(tick, width);

      for (var light in lights) {
        _drawSirenLight(ctx, light.y, light.radius, light.x, light.color, light.alpha);
      }
    }

    ctx.restore();
  }

  void _drawSirenLight(
    CanvasRenderingContext2D sirenCtx,
    int sirenY,
    int sirenRadius,
    double x,
    String color,
    double alpha,
  ) {
    sirenCtx.save();

    sirenCtx.beginPath();
    sirenCtx.arc(x, sirenY, sirenRadius, 0, 2 * pi);
    sirenCtx.fillStyle = 'rgba($color, $alpha)';
    sirenCtx.fill();

    sirenCtx.restore();
  }

  void _animateSirenLights(CanvasRenderingContext2D sirenCtx) {
    tick += 1;

    final sirenRadius = 3;
    const maxLightAlpha = 0.8;

    // Define initial siren positions relative to car width
    double redX = -width / 2 * 0.3;
    double blueX = width / 2 * 0.3;
    final sirenY = 5;

    // Function to draw a siren light

    double redAlpha = (sin(tick * 0.2) + 1) * maxLightAlpha / 2;
    double blueAlpha = (cos(tick * 0.2) + 1) * maxLightAlpha / 2;

    // Draw siren lights with calculated alpha
    _drawSirenLight(sirenCtx, sirenY, sirenRadius, redX, '255, 0, 0', redAlpha); // Red color in rgba
    _drawSirenLight(sirenCtx, sirenY, sirenRadius, blueX, '0, 0, 255', blueAlpha); // Blue color in rgba;
  }

  @override
  update(List<List<Point>> roadBorders, List<GameObject> traffic) {
    super.update(roadBorders, traffic);

    if (damaged) {
      return;
    }

    final oldX = x;

    move();
    polygon = createPolygon();

    sensor?.update(x, y, angle, roadBorders, traffic);

    if (sensor != null && brain != null) {
      var offsets = sensor?.readings.map((reading) => reading == null ? 0 : 1 - reading.offset).toList();

      var output = brain!.forward(offsets!.map((e) => e.toDouble()).toList());

      controls.forward = output[0] >= 1;
      controls.left = output[1] >= 1;
      controls.right = output[2] >= 1;
      controls.reverse = output[3] >= 1;
    }

    if (controlType == CarControlTypes.dummy && sensor != null) {
      var sensorActived = false;

      for (var i = 0; i < sensor!.readings.length; i++) {
        if (sensor?.readings[i] == null) {
          continue;
        }

        //int i = 5; // Valor de i a ser consultado
        int minI = 0; // Valor mínimo de i
        int maxI = sensor!.readings.length - 1; // Valor máximo de i
        double minX = 0.2; // Valor mínimo de x
        double maxX = 0.4; // Valor máximo de x

        switch (carModel.getInfo()['type']) {
          case CarType.car:
            maxX = 0.4;
            break;
          case CarType.truck:
            maxX = 0.4;
            break;
          case CarType.carLong:
            minX = 0.3;
            maxX = 0.5;
            break;
          case CarType.truckLong:
            minX = 0.3;
            maxX = 0.6;

            break;
          case CarType.bus:
            minX = 0.3;
            maxX = 0.6;
            break;
        }

        sensorActived = sensorActived || sensor?.readings[i]?.offset <= calcularValorLinear(i, minI, maxI, minX, maxX);
      }

      controls.reverse = sensorActived;

      if (sensorActived) {
        speed -= acceleration * 1.5;

        if (speed < 0) {
          speed = 0;
        }
      }
    }

    if (maxPenalty != 0) {
      var rFirst = sensor?.readings[0];
      var rLast = sensor?.readings[sensor!.readings.length - 1];

      if (rFirst != null && rFirst.offset <= 0.2) {
        //angle -= 0.05;
        //penalty += 10;
      } else if (rLast != null && rLast.offset <= 0.2) {
        //angle += 0.05;
        //penalty += 10;
      }

      if (controls.forward == false || controls.forward == true && controls.reverse == true) {
        penalty += 1;
      }

      if (oldX.toPrecision(4) == x.toPrecision(4)) {
        penalty += 1;
      } else {
        penalty -= 1;
      }

      if (penalty <= maxPenalty * -1) {
        penalty = maxPenalty * -1;
      }

      if (penalty >= maxPenalty) {
        damaged = true;
        penalty = maxPenalty;
      }
    }
  }

  @override
  void move() {
    if (controlType == CarControlTypes.keys) {
      drawLights = controls.lights;
    }

    if (controls.forward) {
      speed += acceleration;
    }

    if (controls.reverse) {
      speed -= acceleration;
    }

    if (speed > maxSpeed) {
      speed = maxSpeed;
    }

    if (speed < -maxSpeed / 2) {
      speed = -maxSpeed / 2;
    }

    if (speed > 0) {
      speed -= friction;
    }

    if (speed < 0) {
      speed += friction;
    }

    if (speed.abs() < friction) {
      speed = 0;
    }

    if (speed != 0) {
      var flip = speed > 0 ? 1 : -1;

      if (controls.left) {
        angle += 0.03 * flip;
      }

      if (controls.right) {
        angle -= 0.03 * flip;
      }
    }

    x -= (sin(angle) * speed);
    y -= (cos(angle) * speed);
  }
  //

  @override
  void dispose() {
    //
  }
}
