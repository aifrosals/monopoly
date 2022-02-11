import 'package:flutter/material.dart';
import 'package:monopoly/web/admin/pages/admin_login.dart';

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
      home: const AdminLogin(),
    );
  }
}
