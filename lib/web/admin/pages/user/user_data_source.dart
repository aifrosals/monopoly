import 'package:flutter/material.dart';
import 'package:monopoly/config/date_utility.dart';
import 'package:monopoly/models/user.dart';

class UserDataSource extends DataTableSource {
  final List<User> users;

  UserDataSource({required this.users});

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
    ]);
  }
}
