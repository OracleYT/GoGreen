import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static Color themeColor = Colors.black;
  static Color themeColorLight = Color.fromRGBO(79, 171, 93, 1);
  static Color buttonColor = Color.fromRGBO(18, 93, 116, 1);
  static LinearGradient labGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: const [
        Color.fromRGBO(18, 93, 116, 1),
        Color.fromRGBO(79, 171, 93, 1)
      ]);
}
