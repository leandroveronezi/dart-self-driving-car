import 'dart:html';

import 'lib/game/game.dart';

void main() {
  bool isGame = false;

  if (Uri.base.queryParameters.containsKey("game")) {
    isGame = true;
  }

  var roadLane = isGame ? 4 : 3;

  if (Uri.base.queryParameters.containsKey("lane")) {
    try {
      roadLane = int.parse(Uri.base.queryParameters["lane"] as String);
    } catch (e) {
      roadLane = 3;
    }
  }

  if (roadLane < 2) {
    roadLane = 2;
  }

  var game = Game(
    gameType: !isGame ? GameType.trainer : GameType.key,
    trafficGenerateSpecialsItens: isGame,
    roadLane: roadLane,
  );

  game.animate(0);

  if (isGame) {
    (document.getElementById("saveButton") as Element).style.display = "none";
    (document.getElementById("discardButton") as Element).style.display = "none";
    (document.getElementById("exportButton") as Element).style.display = "none";
    (document.getElementById("importButton") as Element).style.display = "none";
  }

  (document.getElementById("saveButton") as Element).onClick.listen((event) {
    game.storage.save();
  });

  (document.getElementById("discardButton") as Element).onClick.listen((event) {
    game.storage.discard();
  });

  (document.getElementById("exportButton") as Element).onClick.listen((event) {
    game.storage.exportFile();
  });

  (document.getElementById("importButton") as Element).onClick.listen((event) {
    game.storage.importFile();
  });
}
