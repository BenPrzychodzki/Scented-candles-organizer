import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:flutter/material.dart';

  Future<int> getAvgColor(File image) async {
  img.Image bitmap = img.decodeImage(image.readAsBytesSync());

  List<int> rgb = [0,0,0];
  int pixelCount = 0;

  for (int y = (0.1*bitmap.height).toInt(); y < 0.9*bitmap.height; y++){
    for (int x = (0.1*bitmap.width).toInt(); x < 0.9*bitmap.width; x++){
        int color = bitmap.getPixel(x, y);
        if (img.getBlue(color) !=255 || img.getGreen(color) != 255 || img.getRed(color) != 255) {
          pixelCount++;
          rgb[0] += img.getRed(color);
          rgb[1] += img.getGreen(color);
          rgb[2] +=img.getBlue(color);
        }
    }
  }
  Color avgColor = Color.fromRGBO(rgb[0] ~/ pixelCount,rgb[1] ~/ pixelCount,rgb[2] ~/ pixelCount,1);
  return avgColor.value;


}