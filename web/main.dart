import 'dart:html';

import 'lib/game/game.dart';

void main() {
  bool isGame = false;

  if (Uri.base.queryParameters.containsKey("game")) {
    isGame = true;
  }

  var game = Game(
    gameType: !isGame ? GameType.trainer : GameType.key,
    trafficGenerateSpecialsItens: isGame,
    roadLane: isGame ? 4 : 3,
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
