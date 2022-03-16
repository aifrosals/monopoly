import 'package:flutter/material.dart';
import 'package:monopoly/web/admin/pages/challenge/challenge_menu.dart';
import 'package:monopoly/web/admin/pages/user/manage_user.dart';

class AdminDashboard extends StatefulWidget {
  static const String route = '/dashboard';

  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _index = 0;

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
            child: Material(
              color: Colors.grey[300],
              child: Column(
                children: [
                  ListTile(
                      title: Text('Challenge',
                          style: TextStyle(
                              color:
                                  _index == 1 ? Colors.white : Colors.black)),
                      tileColor: _index == 1 ? Colors.black : Colors.white,
                      onTap: () {
                        setState(() {
                          _index = 1;
                        });
                      }),
                  ListTile(
                      title: Text('Users',
                          style: TextStyle(
                              color:
                                  _index == 2 ? Colors.white : Colors.black)),
                      tileColor: _index == 2 ? Colors.black : Colors.white,
                      onTap: () {
                        setState(() {
                          _index = 2;
                        });
                      }),
                ],
              ),
            ),
          ),
          Expanded(flex: 9, child: getMainWidgets())
        ],
      ),
    );
  }

  getMainWidgets() {
    switch (_index) {
      case 0:
        {
          return const Text('Home');
        }
      case 1:
        {
          return const ChallengeMenu();
        }
      case 2:
        {
          return const ManageUserPage();
        }
    }
  }
}
