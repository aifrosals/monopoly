import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  static const String route = '/dashboard';

  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Dashboard'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey[300],
              child: Column(
                children: [
                  ListTile(
                      title: const Text('Challenge'),
                      tileColor: Colors.white,
                      onTap: () {}),
                ],
              ),
            ),
          ),
          Expanded(flex: 9, child: Text('menu'))
        ],
      ),
    );
  }
}
