import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:monopoly/pages/3d/cube.dart';
import 'package:rive/rive.dart';

class CubeMainPage extends StatelessWidget {
  const CubeMainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      body: SafeArea(
          child: SizedBox(
              height: 30,
              width: 30,
              child: RiveAnimation.asset(
                'assets/animations/dice.riv',
                animations: ['face4'],
              ))),
    );
  }
}
