import 'dart:html';

enum CarControlTypes {
  keys,
  ai,
  dummy,
  static,
}

class Controls {
  bool forward = false;
  bool left = false;
  bool right = false;
  bool reverse = false;
  bool lights = false;

  CarControlTypes controlType;

  Controls({
    required this.controlType,
  }) {
    switch (controlType) {
      case CarControlTypes.dummy:
        forward = true;
        break;
      case CarControlTypes.keys:
        _addKeyboardListener();
        break;
      case CarControlTypes.ai:
        // TODO: Handle this case.
        break;
      case CarControlTypes.static:
        forward = false;
        left = false;
        right = false;
        reverse = false;
        break;
    }
  }

  @override
  String toString() {
    return 'Controls{forward: $forward, left: $left, right: $right, reverse: $reverse}';
  }

  _addKeyboardListener() {
    //

    document.onKeyPress.listen(
      (event) {
        switch (event.key) {
          case "L":
          case "l":
            lights = !lights;
            break;
        }
      },
    );

    document.onKeyDown.listen(
      (event) {
        switch (event.keyCode) {
          case KeyCode.UP:
            forward = true;
            break;
          case KeyCode.LEFT:
            left = true;
            break;
          case KeyCode.RIGHT:
            right = true;
            break;
          case KeyCode.DOWN:
            reverse = true;
            break;
        }
      },
    );

    document.onKeyUp.listen(
      (event) {
        switch (event.keyCode) {
          case KeyCode.UP:
            forward = false;
            break;
          case KeyCode.LEFT:
            left = false;
            break;
          case KeyCode.RIGHT:
            right = false;
            break;
          case KeyCode.DOWN:
            reverse = false;
            break;
        }
      },
    );
  }
}
