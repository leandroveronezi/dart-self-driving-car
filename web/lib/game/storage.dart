import 'dart:convert';
import 'dart:html';

class Storage {
  int generation;
  int score;
  Map<String, dynamic> brain = {};

  Storage({
    this.generation = 0,
    this.brain = const {},
    this.score = 0,
  });

  save() {
    window.localStorage.addAll(
      {
        'brain': json.encode(brain),
        'generation': generation.toString(),
        'score': score.toString(),
      },
    );
  }

  discard() {
    window.localStorage.remove('brain');
    window.localStorage.remove('bestBrain');

    window.localStorage.addAll(
      {
        'generation': 0.toString(),
        'score': 0.toString(),
      },
    );
  }

  bool load() {
    if (window.localStorage['brain'] == null) {
      return false;
    }

    brain = window.localStorage['brain'] == null ? {} : json.decode(window.localStorage['brain'].toString());
    generation = window.localStorage['generation'] == null ? 0 : int.parse(window.localStorage['generation'].toString());
    score = window.localStorage['score'] == null ? 0 : int.parse(window.localStorage['score'].toString());

    return true;
  }

  exportFile() {
    var fileContent = {
      'generation': generation.toString(),
      'brain': brain,
      'score': score.toString(),
    };

    var blob = Blob(
      [
        json.encode(
          fileContent,
        ),
      ],
      'application/json',
    );

    var url = Url.createObjectUrl(blob);

    var a = document.createElement('a') as AnchorElement;
    a.href = url;
    a.download = 'brain.json';
    a.click();

    Url.revokeObjectUrl(url);
  }

  importFile() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
      (e) {
        final files = uploadInput.files;

        if (files == null) {
          window.alert('Selecione um arquivo');
          return;
        }

        if (files.length != 1) {
          window.alert('Selecione apenas um arquivo');
          return;
        }

        final file = files[0];
        final reader = FileReader();

        reader.onLoadEnd.listen(
          (e) {
            try {
              final content = reader.result as String;

              final importedData = json.decode(content);

              // Faça algo com os dados importados, por exemplo:
              generation = int.parse(importedData['generation']);
              score = int.parse(importedData['score']);

              brain = Map<String, dynamic>.from(importedData['brain']);

              save(); // Salve os dados importados no armazenamento local

              window.alert('Arquivo importado com sucesso!');
            } catch (e) {
              window.alert('Erro ao importar arquivo: $e');
            }
          },
        );

        reader.readAsText(file);
      },
    );
  }

  /// Returns a pre-trained brain configuration represented by a tuple containing generation, score and the brain.
  (int, int, Map<String, dynamic>) preTrainedBrain() {
    return (
      54,
      330347,
      {
        "layers": [
          {
            "neurons": [
              {
                "weights": [0.19022755003236158, 0.6203647482296231, -0.19748119906041364, -0.8965970252862654, -0.25187559318878483, 0.07421427096896056, -0.018631445791347626, -0.2549687531841497, -0.39607483836872914],
                "bias": -0.052626592063113486
              },
              {
                "weights": [-0.21296689978742278, -0.055587753848772736, 0.1054422393136472, -0.022632105275646394, -0.03592544151778455, -0.16706182881282294, 0.025612095737271117, -0.45497399890284906, -0.3419871400224957],
                "bias": 0.05455993060480313
              },
              {
                "weights": [0.09648866111748955, 0.2642264238790981, -0.24372513942674662, -0.02682932147805002, -0.18525945297390845, -0.04354462068423482, -0.24919928327741925, -0.30048748413271564, 0.039934042842576505],
                "bias": -0.1354094513180811
              },
              {
                "weights": [-0.4452993776181701, 0.20492833020058457, 0.9189954791375659, 0.6598718874530902, 0.024445729259710336, -0.16843101535397503, -0.42118392977565705, 0.03505086291027755, -0.09727797390657167],
                "bias": 0.05347597318433239
              },
              {
                "weights": [0.13759109603058153, 0.25018633789415534, -0.31102478457953064, -0.3039438443146549, -0.18559137711404092, -0.3048099684430935, -0.6944732559183024, -0.3584852999510024, 0.6523971202320146],
                "bias": 0.10253706307236876
              },
              {
                "weights": [-0.15540986074897756, -0.1576459226259944, -0.13949231254685124, -0.09251204122190569, -0.1837114717946377, -0.13180726375231214, -0.17744657040237288, 0.035522196571282305, -0.1398505313374617],
                "bias": 0.46434553372204046
              }
            ]
          },
          {
            "neurons": [
              {
                "weights": [-0.37600000187729266, -0.3152097795690437, -0.05852266883590602, -0.27872130388394245, -0.11618635138111238, 0.44944391464225214],
                "bias": -0.3181764250042944
              },
              {
                "weights": [0.04452136729642986, 0.04245543777367679, 0.2327139063657067, -0.24482088830833626, -0.222359623531803, -0.18006943151072732],
                "bias": 0.13644811578630733
              },
              {
                "weights": [-0.09648634778234372, -0.0012376463449232725, 0.22460228198009702, 0.10709033581209274, -0.9785428944440033, -0.12674522697146084],
                "bias": 0.18630919138487456
              },
              {
                "weights": [-0.06345563400328005, -0.016091414145009073, -0.14818622826249694, 0.33283650026106915, -0.06670943318968574, 0.1723598612840613],
                "bias": 0.8537988528529574
              }
            ]
          }
        ],
        "funcaoAtivacao": "relu"
      },
    );
  }
}
