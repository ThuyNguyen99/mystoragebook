import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      width: 100,
      height: 100,
      child: AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 1000),
        child: Container(
          height: 80,
          width: 80,
          child: Center(
            child: ClipOval(
              child: Icon(
                color: Color.fromARGB(255, 18, 161, 63),
                Icons.android_outlined,
                size: 80,
              ),
            ),
          ),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                color: Color.fromARGB(66, 0, 0, 0),
                offset: Offset(0, 3),
              )
            ],
          ),
          padding: const EdgeInsets.all(5.0),
        ),
      ),
    );
  }
}
