import 'package:flutter/gestures.dart';
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
            return ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: PaginatedDataTable(
                source: UserDataSource(
                    users: adminUserProvider.users, context: context),
                //    header: const Text('My Products'),
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('User Name')),
                  DataColumn(label: Text('User ID')),
                  DataColumn(label: Text('Credits ID')),
                  DataColumn(label: Text('Dice')),
                  DataColumn(label: Text('Add dice')),
                  DataColumn(label: Text('Premium'))
                ],

                columnSpacing: 100,
                horizontalMargin: 10,
                rowsPerPage: 8,
                showCheckboxColumn: false,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}