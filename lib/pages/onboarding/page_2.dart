import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  const Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          minRadius: 150,
          backgroundImage: AssetImage('assets/images/city2.png'),
        ),
        SizedBox(height: 10),
        Text('Buy and rent properties')
      ],
    );
  }
}
