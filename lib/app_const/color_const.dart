import 'dart:ui';

import 'package:flutter/material.dart';

class ColorConst{

  static List<Color> priorityColor = [
    ColorConst().mColor[4],
    ColorConst().mColor[2],
    ColorConst().mColor[3],
  ];
  List<Color> mColor=[
    Color.fromARGB(255, 10,175,167), //0
    Colors.lightBlue, //1
    Colors.orangeAccent,  //2
    Colors.redAccent,//3
    Colors.lightGreen,//4
  ];
}