## Self-driving car in Dart

![Screenshot of the project!](/img/screenshot.bmp)

This project is a simple example of a self-driving car controlled by an artificial neural network, implemented in Dart.

The goal is to learn about neural networks and how to use them to control a virtual car in a game environment.

**Inspiration:**

The project is inspired by the [Self-driving Car (no libraries) JavaScript course](https://www.youtube.com/playlist?list=PLB0Tybl0UNfYoJE7ZwsBQoDIG4YN9ptyY).

**What you need:**

* Dart SDK installed: [https://dart.dev/](https://dart.dev/)
* Git installed: [https://git-scm.com/](https://git-scm.com/)

**Getting started:**

1. Clone the repository:
   ```bash
   git clone https://github.com/leandroveronezi/dart-self-driving-car.git
   ```

2. Access the project folder:
   ```bash
   cd dart-self-driving-car
   ```

3. Activate webdev:
   ```bash
   dart pub global activate webdev
   ```

4. Start the server:
   ```bash
   webdev serve
   ```

5. Access the project:
   ```
   http://localhost:8080
   ```

**How it works:**

* The neural network has 7 inputs, representing the distance to the obstacles in front.
* The neural network has 4 outputs, representing the vehicle control.
* The car is controlled by the neural network, which is trained to minimize the error relative to a goal. The goal is for the car to follow a track without colliding with walls or other cars.

**Developing:**

* Explore the code to understand how the neural network is implemented and how the car is controlled.
* Experiment with different neural network configurations to see how the car's performance changes.
* Implement new features, such as obstacles or different tracks.

**Resources:**

* [Dart](https://dart.dev/): The programming language.
* [Webdev](https://dart.dev/tools/webdev): Tool for web development in Dart.


**Notes:**
* The code is for educational purposes only.

**Enjoy learning!**
