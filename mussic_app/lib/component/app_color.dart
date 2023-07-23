import 'package:flutter/animation.dart';

import 'package:flutter/material.dart';

class appColor{
  static const Color primaryColor = Color(0xff110929);
  static const Color secondColor = Color(0xff0B0F2F);
  static const Color LinearGradient1 = Color(0xff892FE0);
  static const Color LinearGradient2 = Color(0xff0F0817);
  static const Color LightGray = Color(0xFFF2F2F2);
  static const Color darkGrey = Color(0xff444444);
  static const Color blue = Color(0xFF3D58F8);
  static const Color pink = Color(0xffDB28A9);
  static const Color LinearGradientButtonPlay1 = Color(0xff8D1CFE);
  static const Color LinearGradientButtonPlay2 = Color(0xff0038ED);
}

class gradient{
  static const Gradient defaultGradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 86, 28, 141),
      Color.fromARGB(255, 35, 9, 57)
    ]
  );
  static const Gradient GradientButtonPlay = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      appColor.LinearGradientButtonPlay1,
      appColor.LinearGradientButtonPlay2
    ],
  );
  
  static const Gradient GradientChart = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromARGB(255, 41, 18, 79),
      Color(0xff120822),
      Color.fromARGB(255, 41, 18, 79),
    ],
  );
  static const Gradient GradientPlayMussic = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [
      0,
      0.6,
      0.8
    ],
    colors: [
     Colors.transparent,
     Color.fromARGB(255, 80, 27, 129),
     Color.fromARGB(255, 80, 27, 129),
    ],
  );
  static const Gradient GradientTop3 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(255, 2, 111, 75),
      Color(0xff555555),
      Color(0xff020024),
    ],
  );
  static const Gradient GradientTop4 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffdd1818),
      Color(0xff020024),
    ],
  );
  static const Gradient GradientTop5 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffdd1818),
      Color(0xff333333),
    ],
  );
  static const Gradient GradientTop6 = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffdd1818),
      Color(0xff333333),
    ],
  );
}