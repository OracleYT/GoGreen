import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static Color themeColor = Colors.black;
  static Color themeColorLight = const Color.fromRGBO(28, 64, 142, 0.2);
  static Color buttonColor = const Color.fromRGBO(28, 64, 142, 1);
  static Color assignmentColor = const Color(0xff3F8FEE);
  static LinearGradient labGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color.fromRGBO(18, 93, 116, 1),
        Color.fromRGBO(79, 171, 93, 1)
      ]);
}
