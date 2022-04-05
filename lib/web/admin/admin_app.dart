import 'package:flutter/material.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/web/admin/pages/admin_dashboard.dart';
import 'package:monopoly/web/admin/pages/admin_login.dart';
import 'package:monopoly/web/admin/pages/challenge/question_menu.dart';
import 'package:provider/provider.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Monopoly Admin Portal',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey[200],
          ),
          primarySwatch: Colors.grey,
        ),
        navigatorKey: Values.adminNavigatorKey,
        initialRoute: '/',
        routes: {
          AdminDashboard.route: (context) => const AdminDashboard(),
          QuestionMenu.route: (context) => const QuestionMenu()
        },
        home: Consumer<AdminProvider>(builder: (context, adminProvider, child) {
          if (adminProvider.sessionLoading) {
            return const Scaffold(
              body: LinearProgressIndicator(),
            );
          } else if (adminProvider.admin != null) {
            return const AdminDashboard();
          } else {
            return const AdminLogin();
          }
        }));
  }
}
