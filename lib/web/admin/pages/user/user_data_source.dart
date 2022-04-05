import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/admin_user_provider.dart';
import 'package:monopoly/web/widgets/user_add_dices_dialog.dart';
import 'package:monopoly/web/widgets/user_change_premium_dialog.dart';
import 'package:provider/provider.dart';

class UserDataSource extends DataTableSource {
  final List<User> users;
  final BuildContext context;

  UserDataSource({
    required this.users,
    required this.context,
  });

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text('${index + 1}')),
      DataCell(Text(users[index].id)),
      DataCell(Text(users[index].serverId)),
      DataCell(Text('${users[index].credits}')),
      DataCell(Row(
        children: [
          Text('${users[index].dice}'),
        ],
      )),
      DataCell(
        Consumer2<AdminProvider, AdminUserProvider>(
            builder: (context, adminProvider, adminUserProvider, child) {
          return IconButton(
            onPressed: () async {
              var res = await showDialog(
                  context: context,
                  builder: (context) => const UserAddDicesDialog());
              if (res.runtimeType == int && res != null) {
                adminUserProvider.addDices(
                    adminProvider.admin!, users[index], res);
              }
            },
            icon: const Icon(Icons.add_outlined),
          );
        }),
      ),
      DataCell(Consumer2<AdminProvider, AdminUserProvider>(
          builder: (context, adminProvider, adminUserProvider, child) {
        return CupertinoSwitch(
          onChanged: (value) async {
            users[index].premium = value;
            adminUserProvider.setState();
            bool res = await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => UserChangePremiumDialog(premium: value));
            if (!res) {
              users[index].premium = !value;
              adminUserProvider.setState();
            } else {
                  await adminUserProvider.setPremiumStatus(
                  adminProvider.admin!, users[index], value);
            }
          },
          value: users[index].premium,
          activeColor: Colors.blue,
        );
      })),
    ]);
  }
}
