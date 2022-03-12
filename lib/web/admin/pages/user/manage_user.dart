import 'package:flutter/material.dart';
import 'package:monopoly/providers/admin_user_provider.dart';
import 'package:monopoly/web/admin/pages/user/user_list.dart';
import 'package:provider/provider.dart';

class ManageUserPage extends StatelessWidget {
  const ManageUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AdminUserProvider(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration.collapsed(hintText: 'Search'),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue, primary: Colors.white),
                    onPressed: () {},
                    child: Text('Go'))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            UserList(),
          ],
        ),
      ),
    );
  }
}
