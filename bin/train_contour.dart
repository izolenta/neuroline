import 'dart:io';
import 'dart:math';

import 'package:image/image.dart';
import 'package:perceptron/perceptron.dart';

void main(List args) async {
  final bytes_orig = File('keanu.png').readAsBytesSync();
  final bytes_dest = File('keanu_result.png').readAsBytesSync();
  final perceptron = Perceptron([36, 40, 36], 1);
  final trainData = <TrainingData>[];
  final imageOrig = decodeImage(bytes_orig);
  final imageDest = decodeImage(bytes_dest);
  final width = imageOrig.width;
  final height = imageOrig.height;
  final rand = Random();
  for (var cnt=0; cnt<100000; cnt++) {
    final x = rand.nextInt(width-6);
    final y = rand.nextInt(height-6);
    final sourceBlock = <double>[];
    final destinationBlock = <double>[];
    for (var i=0; i<6; i++) {
      for (var j=0; j<6; j++) {
        sourceBlock.add((imageOrig.getPixel(x+j, y+i) % 256) / 256);
        destinationBlock.add((imageDest.getPixel(x+j, y+i) % 256) / 256);
      }
    }
    trainData.add(TrainingData(sourceBlock, destinationBlock));
  }
  perceptron.train(trainData);
  final result = File('trained.json');
  result.writeAsStringSync(perceptron.toJson());
  print(perceptron.toJson());
}



