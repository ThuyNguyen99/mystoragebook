import 'dart:math';

import 'package:flutter/material.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      transform: Matrix4.rotationZ(-9 * pi / 180)..translate(-10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Color.fromARGB(255, 255, 159, 130),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Color.fromARGB(66, 0, 0, 0),
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Text(
        'My Book',
        style: TextStyle(
          color: Theme.of(context).textTheme.headline6?.color,
          fontSize: 50,
          fontFamily: 'Anton',
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
