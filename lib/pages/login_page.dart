import 'package:flutter/material.dart';

import 'board_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100]!,
        leading: const Icon(Icons.menu),
        title: const Text('Monopoly'),
        elevation: 0,
        actions: const [Icon(Icons.notifications)],
      ),
      body: Center(
          child: TextButton(
              style: TextButton.styleFrom(
                  primary: Colors.pink, backgroundColor: Colors.grey[200]),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const BoardPage()));
              },
              child: const Text('Login'))),
    );
  }
}
