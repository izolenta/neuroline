import 'dart:io';

import 'package:image/image.dart';
import 'package:perceptron/perceptron.dart';

void main(List<String> args) async {
  final perceptron = Perceptron.fromJson(File('trained.json').readAsStringSync());

  final bytes_orig = File(args[0]).readAsBytesSync();
  final imageOrig = grayscale(decodeImage(bytes_orig));
  final width = imageOrig.width;
  final height = imageOrig.height;
  final widthRes = width ~/6 * 6 - 6;
  final heightRes = height ~/6 * 6 - 6;
  var imageDest = Image(widthRes, heightRes);
  imageDest = fillRect(imageDest, 0, 0, widthRes, heightRes, 0xFFFFFFFF);
  for (var i=0; i<heightRes-6; i+=3) {
    for (var j = 0; j < widthRes - 6; j+=3) {
      final input = <double>[];
      for (var y=0; y<6; y++) {
        for (var x=0; x<6; x++) {
          input.add((imageOrig.getPixel(j+x, i+y)%256)/256);
        }
      }
      final output = perceptron.process(input);
      for (var y=0; y<6; y++) {
        for (var x=0; x<6; x++) {
          final byte = (output[y*6+x]*256).toInt();
          imageDest.setPixelRgba(j+x, i+y, byte, byte, byte);
        }
      }
    }
    print('y = $i');
  }
  final filename = args[0].split('.').first;
  File('${filename}_result.png').writeAsBytesSync(encodePng(imageDest));
}



