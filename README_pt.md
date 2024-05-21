## Self-driving car em Dart

![Screenshot of the project!](/img/screenshot.bmp)

Este projeto é um exemplo simples de um carro autônomo controlado por uma rede neural artificial, implementado em Dart.

O objetivo é aprender sobre redes neurais e como utilizá-las para controlar um carro virtual em um ambiente de jogo.

**Inspiração:**

O projeto se inspira no curso [Self-driving Car (no libraries) JavaScript course](https://www.youtube.com/playlist?list=PLB0Tybl0UNfYoJE7ZwsBQoDIG4YN9ptyY).

**O que você precisa:**

* Dart SDK instalado: [https://dart.dev/](https://dart.dev/)
* Git instalado: [https://git-scm.com/](https://git-scm.com/)

**Começando:**

1. Clone o repositório:
   ```bash
   git clone https://github.com/leandroveronezi/dart-self-driving-car.git
   ```

2. Acesse a pasta do projeto:
   ```bash
   cd dart-self-driving-car
   ```

3. Ative o webdev:
   ```bash
   dart pub global activate webdev
   ```

4. Inicie o servidor:
   ```bash
   webdev serve
   ```

5. Acesse o projeto:
   ```
   http://localhost:8080
   ```

**Como funciona:**

* A rede neural possui 7 entradas, representando a distância para os obstáculos p frente.
* A rede neural possui 4 saídas, representando o controle do veículo.
* O carro é controlado pela rede neural, que é treinada para minimizar o erro em relação a um objetivo. O objetivo é que o carro siga uma pista sem colidir com as paredes ou outros carros.

**Desenvolvendo:**

* Explore o código para entender como a rede neural é implementada e como o carro é controlado.
* Experimente com diferentes configurações da rede neural para observar como o desempenho do carro muda.
* Implemente novas funcionalidades, como obstáculos ou diferentes pistas.

**Recursos:**

* [Dart](https://dart.dev/): A linguagem de programação.
* [Webdev](https://dart.dev/tools/webdev): Ferramenta para desenvolvimento web em Dart.


**Observações:**
* O código é apenas para fins educacionais.

**Aproveite o aprendizado!**