
import 'package:flutter/material.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: const [
          ListTile(
            tileColor: Colors.grey,
            title: Text('Start'),
          )
        ],
      )
    );
  }
}
