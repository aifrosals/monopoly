import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CircleAvatar(
          minRadius: 150,
          backgroundImage: AssetImage('assets/images/monopoly_group.jpg'),
        ),
        SizedBox(height: 10),
        Text('Play a fun game of Monopoly')
      ],
    );
  }
}
