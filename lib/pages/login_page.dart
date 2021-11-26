import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text('Monopoly'),
        actions: const [Icon(Icons.notifications)],
      ),
      body: Center(child: TextButton(onPressed: () {}, child: const Text('Login'))),
    );
  }
}
