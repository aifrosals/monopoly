import 'package:flutter/material.dart';
import 'package:monopoly/providers/admin_user_provider.dart';
import 'package:monopoly/web/admin/pages/user/user_data_source.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            children: [
              Consumer<AdminUserProvider>(
                  builder: (context, adminQuestionProvider, child) {
                return adminQuestionProvider.userLoading
                    ? const LinearProgressIndicator()
                    : const SizedBox();
              }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
          Consumer<AdminUserProvider>(
              builder: (context, adminUserProvider, child) {
            return PaginatedDataTable(
              source: UserDataSource(users: adminUserProvider.users),
              //    header: const Text('My Products'),
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('User Name')),
                DataColumn(label: Text('User ID'))
              ],
              columnSpacing: 100,
              horizontalMargin: 10,
              rowsPerPage: 8,
              showCheckboxColumn: false,
            );
            // return Table(
            //     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            //     columnWidths: const {
            //       0: FlexColumnWidth(1),
            //     },
            //     children: adminUserProvider.users
            //         .asMap()
            //         .map(
            //           (index, u) => MapEntry(
            //             index,
            //             TableRow(
            //               decoration: BoxDecoration(
            //                   borderRadius: BorderRadius.circular(12),
            //                   color: index.isEven
            //                       ? Colors.grey[200]
            //                       : Colors.white),
            //               children: [
            //                 Text('${index + 1}'),
            //                 Text(u.id),
            //                 Text((u.serverId),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         )
            //         .values
            //         .toList());
          }),
        ],
      ),
    );
  }
}
