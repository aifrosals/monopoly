import 'dart:math';

import 'package:flutter/material.dart';

class Pseudo3dSlider extends StatefulWidget {
  @override
  _Pseudo3dSliderState createState() => _Pseudo3dSliderState();
}

class _Pseudo3dSliderState extends State<Pseudo3dSlider> {
  Map<String, Offset> offsets = {
    'start': Offset(70, 100),
    'finish': Offset(200, 100),
    'center': Offset(100, 200),
  };

  double originX = 0;
  double x = 0;

  void onDragStart(double originX) => setState(() {
        this.originX = originX;
      });

  void onDragUpdate(double x) => setState(() {
        this.x = originX - x;
      });

  double get turnRatio {
    const step = -150.0;
    var k = x / step;
    k = k > 1 ? 1 : (k < 0 ? 0 : k);
    return 1 - k;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanStart: (details) => onDragUpdate(details.globalPosition.dx),
      onPanUpdate: (details) => onDragUpdate(details.globalPosition.dx),
      child: Slider(
        children: [
          _Side(
            color: Colors.blueAccent,
            number: 1,
          ),
          _Side(
            color: Colors.redAccent.shade200,
            number: 2,
          ),
          _Side(
            color: Colors.greenAccent.shade200,
            number: 3,
          ),
        ],
        k: turnRatio,
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({Key? key, required this.color, required this.number})
      : super(key: key);

  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      color: color,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 10,
              decoration:
                  BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            )
          ],
        ),
      ),
    );
  }
}

class Slider extends StatelessWidget {
  Slider({
    Key? key,
    required this.children,
    required this.k,
  }) : super(key: key) {}

  final List<Widget> children;
  final double k;

  @override
  Widget build(BuildContext context) {
    var k1 = k;
    var k2 = 1 - k;
    print(k1);
    print('k2 $k2');
    return Stack(
      children: <Widget>[
        Positioned(
          // left: 95,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi / 2 * -k2)
            //  ..translate(-k2 * 70 - 100,0.0)
            ,
            alignment: Alignment.centerRight,
            child: children[1],
          ),
        ),
        SizedBox(
          // width: 500,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi / 2 * k1),
            alignment: Alignment.centerLeft,
            child: children[0],
          ),
        ),
      ],
    );
  }
}
