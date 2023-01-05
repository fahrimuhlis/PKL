import 'package:flutter/material.dart';

class Warna {
  static Color primary = Color(0xFF1B63DE);
  static Color accent = Colors.blueAccent;
  //
  static Color hijauBG = Color(0xffE3FFEE);
  static Color hijauBG2 = Color(0xfff7fffa);
  static Color kuningTombol = Color(0xffffea00);
  //
  static BoxDecoration bgGradient = BoxDecoration(
    gradient: LinearGradient(
      tileMode: TileMode.mirror,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFFFFF),
        Color(0xFFFFFFFF),
      ],
      stops: [
        0,
        1,
      ],
    ),
    backgroundBlendMode: BlendMode.srcOver,
  );
}

Color hijauMain = Warna.primary;
Color hijauBG = Warna.hijauBG;

class AsetLokal {
  static String iconGoogleMap = 'lib/assets/icon_map.png';
  static String kartuFikri = 'lib/assets/card.png';
}

String rapiin(String s) {
  return s.splitMapJoin(
    RegExp(r'^', multiLine: true),
    onMatch: (_) => '\n',
    onNonMatch: (n) => n.trim(),
  );
}
