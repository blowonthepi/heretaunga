import 'package:flutter/material.dart';

Color colourFromString(String string) {
  // Generate a Hash for the String
  hash(String word) {
    var h = 0;
    for (var i = 0; i < word.length; i++) {
      h = word.codeUnitAt(i) + ((h << 5) - h);
    }
    return h;
  }

  // Convert init to an RGBA
   intToRGBA(int i) {
    var rgb = [
      ((i >> 24) & 0xFF),
      ((i >> 16) & 0xFF),
      ((i >> 8) & 0xFF),
    ];
    return Color.fromRGBO(rgb[0], rgb[1], rgb[2], 1);
  }

  return intToRGBA(hash(string));

}

Color contrastingTextColor(Color color) {
  double lum = color.computeLuminance();
  if(lum < 0.5) return Colors.white;
  else return Colors.black;
}