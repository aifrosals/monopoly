import 'package:flutter/material.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/admin_user_provider.dart';
import 'package:monopoly/web/admin/pages/user/user_list.dart';
import 'package:provider/provider.dart';

class ManageUserPage extends StatelessWidget {
  const ManageUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => AdminUserProvider(adminProvider.admin!),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: Consumer<AdminUserProvider>(
                      builder: (context, adminUserProvider, child) {
                        return TextField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            adminUserProvider.inputQuery(
                            adminProvider.admin!, value);
                      },
                          decoration:
                          const InputDecoration.collapsed(hintText: 'Search'),
                        );
                      }),
                ),
                // TextButton(
                //     style: TextButton.styleFrom(
                //         backgroundColor: Colors.blue, primary: Colors.white),
                //     onPressed: () {},
                //     child: Text('Go'))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Flexible(child: UserList()),
          ],
        ),
      ),
    );
  }
}
