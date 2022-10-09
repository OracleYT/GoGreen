import 'dart:ui';

import 'package:flutter/material.dart';

class GlassBox extends StatelessWidget {
  final child;
  final color;
  final bool isback;
  const GlassBox({Key key, this.child, this.color, this.isback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
          color: color,
          // height: 1
          padding: EdgeInsets.all(2),
          child: isback
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: child,
                  ),
                )
              : Container(
                  alignment: Alignment.bottomCenter,
                  child: child,
                )),
    );
  }
}
