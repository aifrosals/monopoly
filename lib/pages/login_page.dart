import 'package:flutter/material.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'board_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100]!,
        leading: const Icon(Icons.menu),
        title: const Text('Monopoly'),
        elevation: 0,
        actions: const [Icon(Icons.notifications)],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.pink, backgroundColor: Colors.grey[200]),
                onPressed: () {
                  userProvider.login('user1');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BoardPage()));
                },
                child: const Text('Login user 1')),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.pink, backgroundColor: Colors.grey[200]),
                onPressed: () {
                  userProvider.login('user2');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BoardPage()));
                },
                child: const Text('Login user 2')),
            TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.pink, backgroundColor: Colors.grey[200]),
                onPressed: () {
                  userProvider.login('user3');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BoardPage()));
                },
                child: const Text('Login user 3')),
          ],
        ),
      ),
    );
  }
}
