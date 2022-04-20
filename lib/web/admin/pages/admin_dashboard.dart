import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/stats_provider.dart';
import 'package:monopoly/theme/web_palette.dart';
import 'package:monopoly/web/admin/pages/challenge/challenge_menu.dart';
import 'package:monopoly/web/admin/pages/feedback/feedback_list.dart';
import 'package:monopoly/web/admin/pages/stats/stats.dart';
import 'package:monopoly/web/admin/pages/user/manage_user.dart';
import 'package:provider/provider.dart';

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
                      title: Text('Stats',
                          style: TextStyle(
                              color: _index == 0
                                  ? Colors.white
                                  : WebPalette.primary)),
                      tileColor:
                          _index == 0 ? WebPalette.primary : Colors.white,
                      trailing: Icon(
                        CupertinoIcons.news,
                        color: _index == 0 ? Colors.white : WebPalette.primary,
                      ),
                      onTap: () {
                        setState(() {
                          _index = 0;
                        });
                      }),
                  ListTile(
                      title: Text('Challenge',
                          style: TextStyle(
                              color: _index == 1
                                  ? Colors.white
                                  : WebPalette.primary)),
                      tileColor:
                          _index == 1 ? WebPalette.primary : Colors.white,
                      trailing: Icon(
                        CupertinoIcons.bolt_fill,
                        color: _index == 1 ? Colors.white : WebPalette.primary,
                      ),
                      onTap: () {
                        setState(() {
                          _index = 1;
                        });
                      }),
                  ListTile(
                      title: Text('Users',
                          style: TextStyle(
                              color: _index == 2
                                  ? Colors.white
                                  : WebPalette.primary)),
                      tileColor:
                          _index == 2 ? WebPalette.primary : Colors.white,
                      trailing: Icon(
                        CupertinoIcons.doc_person,
                        color: _index == 2 ? Colors.white : WebPalette.primary,
                      ),
                      onTap: () {
                        setState(() {
                          _index = 2;
                        });
                      }),
                  ListTile(
                      title: Text('Message',
                          style: TextStyle(
                              color: _index == 3
                                  ? Colors.white
                                  : WebPalette.primary)),
                      tileColor:
                          _index == 3 ? WebPalette.primary : Colors.white,
                      trailing: Icon(
                        CupertinoIcons.envelope,
                        color: _index == 3 ? Colors.white : WebPalette.primary,
                      ),
                      onTap: () {
                        setState(() {
                          _index = 3;
                        });
                      }),
                ],
              ),
            ),
          ),
          Expanded(flex: 10, child: getMainWidgets())
        ],
      ),
    );
  }

  getMainWidgets() {
    switch (_index) {
      case 0:
        {
          return const Stats();
        }
      case 1:
        {
          return const ChallengeMenu();
        }
      case 2:
        {
          return const ManageUserPage();
        }
      case 3:
        {
          return const FeedbackList();
        }
    }
  }
}
