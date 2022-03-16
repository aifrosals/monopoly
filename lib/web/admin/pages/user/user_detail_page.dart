import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User\'s Details'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              user.id,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              elevation: 2.0,
              child: Column(
                children: [
                  Text('User Credits: ${user.credits}'),
                  Text('User dices: ${user.dice}'),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
