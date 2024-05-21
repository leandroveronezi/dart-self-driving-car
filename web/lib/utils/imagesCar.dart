import 'dart:math';

class DamageImages {
  static const damaged1 = "assets/images/damaged1.png";
  static const damaged2 = "assets/images/damaged2.png";
  static const damaged3 = "assets/images/damaged3.png";
  static const damaged4 = "assets/images/damaged4.png";
  static const damaged5 = "assets/images/damaged5.png";
  static const damaged6 = "assets/images/damaged6.png";
  static const damaged7 = "assets/images/damaged7.png";
  static const damaged8 = "assets/images/damaged8.png";
  static const damaged9 = "assets/images/damaged9.png";
  static const damaged10 = "assets/images/damaged10.png";
}

enum CarType {
  car,
  carLong,
  truck,
  truckLong,
  bus,
}

extension ExCarType on CarType {
  gerSize() {
    switch (this) {
      case CarType.car:
        return {
          'height': 50,
          'width': 30,
        };
      case CarType.carLong:
        return {
          'height': 80,
          'width': 30,
        };
      case CarType.truck:
        return {
          'height': 60,
          'width': 40,
        };
      case CarType.truckLong:
        return {
          'height': 90,
          'width': 40,
        };
      case CarType.bus:
        return {
          'height': 90,
          'width': 40,
        };
    }
  }
}

//!

enum CarModel {
  taxi,
  taxiXpress,
  towTruck,
  armedLandRoamer,
  anistonBD4,
  arachnid,
  aType,
  bType,
  beamer,
  benson,
  boxTruck,
  bug,
  bulwark,
  bus,
  bus2,
  copCar,
  dementiaLimousine,
  eddy,
  fireTruck,
  furoreGT,
  g4BankVan,
  garbageTruck,
  gtA1,
  hachura,
  hotDogVan,
  iceCreamVan,
  jagularXK,
  jefferson,
  karmaBus,
  landRoamer,
  landRoamer2,
  maurice,
  medicar,
  meteor,
  meteor2,
  miara,
  michelliRoadster,
  minx,
  morton,
  pacifier,
  panto,
  pickupGang,
  pickup,
  romero,
  rumbler,
  shark,
  specialAgentCar,
  sportsLimousine,
  spritzer,
  stinger,
  stretchLimousine,
  swatVan,
  tRex,
  tranceAM,
  truckCab,
  truckCabSX,
  tvVan,
  uJerkTruck,
  van,
  wellard,
  zType,
  tank,
}

//!

extension ExCarModel on CarModel {
  //

  gerLights(tick, width) {
    if (this == CarModel.copCar) {
      final sirenRadius = 3;
      const maxLightAlpha = 0.8;

      double redX = -width / 2 * 0.3;
      double blueX = width / 2 * 0.3;

      final sirenY1 = 5;
      final sirenY2 = 9;

      double redAlpha = (sin(tick * 0.15) + 1) * maxLightAlpha / 2;
      double blueAlpha = (cos(tick * 0.15) + 1) * maxLightAlpha / 2;

      return [
        (y: sirenY1, radius: sirenRadius, x: redX, color: '255, 0, 0', alpha: redAlpha),
        (y: sirenY1, radius: sirenRadius, x: blueX, color: '0, 0, 255', alpha: blueAlpha),
        (y: sirenY2, radius: sirenRadius, x: redX, color: '255, 0, 0', alpha: redAlpha),
        (y: sirenY2, radius: sirenRadius, x: blueX, color: '0, 0, 255', alpha: blueAlpha),
      ];
    }

    if (this == CarModel.fireTruck) {
      final sirenRadius = 4;
      const maxLightAlpha = 0.8;

      double redX1 = -width / 2 * 0.4;
      double redX2 = width / 2 * 0.4;

      final sirenY1 = -27;

      double redAlpha1 = (sin(tick * 0.15) + 1) * maxLightAlpha / 2;
      double redAlpha2 = (cos(tick * 0.15) + 1) * maxLightAlpha / 2;

      return [
        (y: sirenY1, radius: sirenRadius, x: redX1, color: '117, 5, 44', alpha: redAlpha1),
        (y: sirenY1, radius: sirenRadius, x: redX2, color: '117, 5, 44', alpha: redAlpha2),
      ];
    }

    if (this == CarModel.medicar) {
      final sirenRadius = 3;
      const maxLightAlpha = 0.8;

      double redX1 = -width / 2 * 0.55;
      double redX2 = -width / 2 * 0.2;

      double redX3 = width / 2 * 0.2;
      double redX4 = width / 2 * 0.55;

      final sirenY1 = -9;
      final sirenY2 = 30;

      double redAlpha1 = (sin(tick * 0.15) + 1) * maxLightAlpha / 2;
      double redAlpha2 = (cos(tick * 0.15) + 1) * maxLightAlpha / 2;

      return [
        (y: sirenY1, radius: sirenRadius, x: redX1, color: '255, 0, 0', alpha: redAlpha1),
        (y: sirenY1, radius: sirenRadius, x: redX4, color: '255, 0, 0', alpha: redAlpha1),

        (y: sirenY1, radius: sirenRadius, x: redX2, color: '255, 0, 0', alpha: redAlpha2),
        (y: sirenY1, radius: sirenRadius, x: redX3, color: '255, 0, 0', alpha: redAlpha2),

        //
        (y: sirenY2, radius: sirenRadius, x: redX1, color: '255, 0, 0', alpha: redAlpha1),
        (y: sirenY2, radius: sirenRadius, x: redX4, color: '255, 0, 0', alpha: redAlpha2),
      ];
    }

    if (this == CarModel.specialAgentCar) {
      final sirenRadius = 4;
      const maxLightAlpha = 0.8;

      double redX = width / 2 * 0.4;

      final sirenY = -1;

      double redAlpha1 = (sin(tick * 0.15) + 1) * maxLightAlpha / 2;

      return [
        (y: sirenY, radius: sirenRadius, x: redX, color: '255, 0, 0', alpha: redAlpha1),
      ];
    }

    if (this == CarModel.swatVan) {
      final sirenRadius = 3;
      const maxLightAlpha = 0.8;

      double X1 = -width / 2 * 0.25;
      double X2 = width / 2 * 0.5;

      final sirenY1 = -12;
      final sirenY2 = 13;

      double alpha1 = (sin(tick * 0.15) + 1) * maxLightAlpha / 2;
      double alpha2 = (cos(tick * 0.15) + 1) * maxLightAlpha / 2;

      return [
        (y: sirenY1, radius: sirenRadius, x: X1, color: '255, 0, 0', alpha: alpha1),
        (y: sirenY1, radius: sirenRadius, x: X1 * -1, color: '255, 0, 0', alpha: alpha2),

        //
        (y: sirenY1 + 4, radius: sirenRadius, x: X1, color: '0, 0, 255', alpha: alpha2),
        (y: sirenY1 + 4, radius: sirenRadius, x: X1 * -1, color: '0, 0, 255', alpha: alpha1),

        (y: sirenY2, radius: sirenRadius, x: X2, color: '255, 0, 0', alpha: alpha2),
        (y: sirenY2, radius: sirenRadius, x: X2 * -1, color: '255, 0, 0', alpha: alpha1),

        //
        (y: sirenY2 + 4, radius: sirenRadius, x: X2, color: '0, 0, 255', alpha: alpha1),
        (y: sirenY2 + 4, radius: sirenRadius, x: X2 * -1, color: '0, 0, 255', alpha: alpha2),
      ];
    }

    return [];
  }

  getInfo() {
    switch (this) {
      case CarModel.taxi:
        return {
          'type': CarType.car,
          'image': "assets/images/taxi.png",
        };
      case CarModel.taxiXpress:
        return {
          'type': CarType.car,
          'image': "assets/images/taxiXpress.png",
        };
      case CarModel.towTruck:
        return {
          'type': CarType.truck,
          'image': "assets/images/towTruck.png",
        };
      case CarModel.armedLandRoamer:
        return {
          'type': CarType.truck,
          'image': "assets/images/armedLandRoamer.png",
        };
      case CarModel.anistonBD4:
        return {
          'type': CarType.car,
          'image': "assets/images/anistonBD4.png",
        };
      case CarModel.arachnid:
        return {
          'type': CarType.car,
          'image': "assets/images/arachnid.png",
        };
      case CarModel.aType:
        return {
          'type': CarType.car,
          'image': "assets/images/aType.png",
        };
      case CarModel.bType:
        return {
          'type': CarType.car,
          'image': "assets/images/bType.png",
        };
      case CarModel.beamer:
        return {
          'type': CarType.car,
          'image': "assets/images/beamer.png",
        };
      case CarModel.benson:
        return {
          'type': CarType.car,
          'image': "assets/images/benson.png",
        };
      case CarModel.boxTruck:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/boxTruck.png",
          'imageDamage': DamageImages.damaged8,
        };
      case CarModel.bug:
        return {
          'type': CarType.car,
          'image': "assets/images/bug.png",
        };
      case CarModel.bulwark:
        return {
          'type': CarType.car,
          'image': "assets/images/bulwark.png",
        };
      case CarModel.bus:
        return {
          'type': CarType.bus,
          'image': "assets/images/bus.png",
        };
      case CarModel.bus2:
        return {
          'type': CarType.bus,
          'image': "assets/images/bus2.png",
        };
      case CarModel.copCar:
        return {
          'type': CarType.car,
          'image': "assets/images/copCar.png",
          'imageDamage': DamageImages.damaged4,
        };
      case CarModel.dementiaLimousine:
        return {
          'type': CarType.carLong,
          'image': "assets/images/dementiaLimousine.png",
        };
      case CarModel.eddy:
        return {
          'type': CarType.car,
          'image': "assets/images/eddy.png",
        };
      case CarModel.fireTruck:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/fireTruck.png",
          'imageDamage': DamageImages.damaged8,
        };
      case CarModel.furoreGT:
        return {
          'type': CarType.car,
          'image': "assets/images/furoreGT.webp",
        };
      case CarModel.g4BankVan:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/g4BankVan.png",
          'imageDamage': DamageImages.damaged8,
        };
      case CarModel.garbageTruck:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/garbageTruck.png",
          'imageDamage': DamageImages.damaged8,
        };
      case CarModel.gtA1:
        return {
          'type': CarType.car,
          'image': "assets/images/gtA1.png",
        };
      case CarModel.iceCreamVan:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/iceCreamVan.png",
          'imageDamage': DamageImages.damaged8,
        };
      case CarModel.jagularXK:
        return {
          'type': CarType.car,
          'image': "assets/images/jagularXK.png",
        };
      case CarModel.jefferson:
        return {
          'type': CarType.car,
          'image': "assets/images/jefferson.png",
        };
      case CarModel.karmaBus:
        return {
          'type': CarType.bus,
          'image': "assets/images/karmaBus.png",
        };
      case CarModel.landRoamer:
        return {
          'type': CarType.truck,
          'image': "assets/images/landRoamer.png",
        };
      case CarModel.landRoamer2:
        return {
          'type': CarType.truck,
          'image': "assets/images/landRoamer2.png",
        };
      case CarModel.maurice:
        return {
          'type': CarType.car,
          'image': "assets/images/maurice.png",
        };
      case CarModel.medicar:
        return {
          'type': CarType.carLong,
          'image': "assets/images/medicar.png",
        };
      case CarModel.meteor:
        return {
          'type': CarType.car,
          'image': "assets/images/meteor.png",
        };
      case CarModel.meteor2:
        return {
          'type': CarType.car,
          'image': "assets/images/meteor2.png",
        };
      case CarModel.miara:
        return {
          'type': CarType.car,
          'image': "assets/images/miara.webp",
        };

      case CarModel.michelliRoadster:
        return {
          'type': CarType.car,
          'image': "assets/images/michelliRoadster.png",
        };
      case CarModel.minx:
        return {
          'type': CarType.car,
          'image': "assets/images/minx.png",
        };
      case CarModel.morton:
        return {
          'type': CarType.car,
          'image': "assets/images/morton.png",
        };
      case CarModel.pacifier:
        return {
          'type': CarType.truck,
          'image': "assets/images/pacifier.png",
        };
      case CarModel.panto:
        return {
          'type': CarType.car,
          'image': "assets/images/panto.png",
        };
      case CarModel.pickupGang:
        return {
          'type': CarType.truck,
          'image': "assets/images/pickup-gang.png",
        };
      case CarModel.pickup:
        return {
          'type': CarType.truck,
          'image': "assets/images/pickup.png",
        };
      case CarModel.romero:
        return {
          'type': CarType.car,
          'image': "assets/images/romero.png",
        };
      case CarModel.rumbler:
        return {
          'type': CarType.car,
          'image': "assets/images/rumbler.png",
        };
      case CarModel.shark:
        return {
          'type': CarType.car,
          'image': "assets/images/shark.png",
        };
      case CarModel.specialAgentCar:
        return {
          'type': CarType.car,
          'image': "assets/images/specialAgentCar.png",
        };
      case CarModel.sportsLimousine:
        return {
          'type': CarType.carLong,
          'image': "assets/images/sportsLimousine.png",
        };
      case CarModel.spritzer:
        return {
          'type': CarType.car,
          'image': "assets/images/spritzer.png",
        };
      case CarModel.stinger:
        return {
          'type': CarType.car,
          'image': "assets/images/stinger.png",
        };
      case CarModel.stretchLimousine:
        return {
          'type': CarType.carLong,
          'image': "assets/images/stretchLimousine.png",
        };
      case CarModel.swatVan:
        return {
          'type': CarType.truck,
          'image': "assets/images/swatVan.webp",
          'imageDamage': DamageImages.damaged9,
        };
      case CarModel.tRex:
        return {
          'type': CarType.car,
          'image': "assets/images/tRex.png",
        };
      case CarModel.tranceAM:
        return {
          'type': CarType.car,
          'image': "assets/images/tranceAM.png",
        };
      case CarModel.truckCab:
        return {
          'type': CarType.truck,
          'image': "assets/images/truckCab.png",
          'imageDamage': DamageImages.damaged2,
        };
      case CarModel.truckCabSX:
        return {
          'type': CarType.truck,
          'image': "assets/images/truckCabSX.png",
        };
      case CarModel.tvVan:
        return {
          'type': CarType.truck,
          'image': "assets/images/tvVan.png",
          'imageDamage': DamageImages.damaged9,
        };
      case CarModel.uJerkTruck:
        return {
          'type': CarType.truck,
          'image': "assets/images/uJerkTruck.png",
        };
      case CarModel.van:
        return {
          'type': CarType.truck,
          'image': "assets/images/van.png",
          'imageDamage': DamageImages.damaged9,
        };
      case CarModel.wellard:
        return {
          'type': CarType.car,
          'image': "assets/images/wellard.png",
        };
      case CarModel.zType:
        return {
          'type': CarType.car,
          'image': "assets/images/zType.png",
        };

      case CarModel.hachura:
        return {
          'type': CarType.car,
          'image': "assets/images/hachura.png",
        };

      case CarModel.hotDogVan:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/hotDogVan.png",
          'imageDamage': DamageImages.damaged8,
        };

      case CarModel.tank:
        return {
          'type': CarType.truckLong,
          'image': "assets/images/tank.png",
          'imageDamage': DamageImages.damaged10,
        };
    }
  }
}

class CarInfo {
  static getRandomCarModel() => CarModel.values[Random().nextInt(CarModel.values.length)];
  static getRandomServiceCar() => [CarModel.medicar, CarModel.fireTruck, CarModel.copCar][Random().nextInt(3)];
  static getRandomMilitarCar() => [CarModel.armedLandRoamer, CarModel.landRoamer, CarModel.landRoamer2, CarModel.tank, CarModel.pacifier][Random().nextInt(5)];
}
