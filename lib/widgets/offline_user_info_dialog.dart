import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';

class OfflineUserInfoDialog extends StatelessWidget {
  final List<User> users;

  const OfflineUserInfoDialog({Key? key, required this.users})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Offline Users',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 160,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('${index + 1}. ${users[index].id}'),
                          )),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
