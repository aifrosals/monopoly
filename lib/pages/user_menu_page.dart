import 'package:flutter/material.dart';
import 'package:monopoly/pages/board_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/slot_graphic.dart';
import 'package:monopoly/widgets/slot_information_dialog.dart';
import 'package:provider/provider.dart';

class UserMenuPage extends StatelessWidget {
  const UserMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Your properties'),
          ),
          Consumer<BoardProvider>(builder: (context, boardProvider, child) {
            if (boardProvider.slots.isEmpty) {
              return const Center(child: Text('Nothing to show'));
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: boardProvider.slots.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (boardProvider.slots[index].owner != null &&
                        boardProvider.slots[index].owner!.serverId ==
                            userProvider.user.serverId) {
                      return SizedBox(
                        height: 90,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            key: boardProvider.slots[index].endKey,
                            decoration: SlotGraphic
                                .getBackgroundImageDecoration(
                                boardProvider.slots[index].type),
                            child: ListTile(
                              dense: true,
                              leading: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  boardProvider.slots[index].status != null &&
                                          boardProvider.slots[index].status! ==
                                              'for_sell'
                                      ? const Text('(For Sell)',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ))
                                      : const SizedBox(),
                                  (boardProvider.slots[index].owner != null &&
                                          boardProvider
                                                  .slots[index].owner?.id !=
                                              null)
                                      ? Text(
                                          ' bought by ${boardProvider.slots[index].owner?.id}',
                                          style: const TextStyle(
                                              color: Colors.white))
                                      : const SizedBox(),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => SlotInformationDialog(
                                        slot: boardProvider.slots[index]));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: boardProvider.slots[index].color,
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                        '${boardProvider.slots[index].name} ',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 20)),
                                  ),
                                  boardProvider.slots[index].type == 'chest'
                                      ? Image.asset(
                                          'assets/images/chest-pro.png',
                                          height: 100,
                                          width: 100,
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        boardProvider.slots[index]
                                                        .allStepCount !=
                                                    null &&
                                                boardProvider
                                                    .slots[index].allStepCount!
                                                    .containsKey(userProvider
                                                        .user.serverId)
                                            ? Container(
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12)),
                                                    color: Colors.indigo),
                                                child: Center(
                                                    child: boardProvider
                                                                .slots[index]
                                                                .type ==
                                                            'reward'
                                                        ? Row(
                                                            children: boardProvider
                                                                .getRewardStars(boardProvider
                                                                        .slots[
                                                                            index]
                                                                        .allStepCount![
                                                                    userProvider
                                                                        .user
                                                                        .serverId]),
                                                          )
                                                        : Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0,
                                                                    right: 8.0),
                                                            child: Text(
                                                                'steps: ${boardProvider.slots[index].allStepCount![userProvider.user.serverId]}',
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                          )),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  });
            }
          }),
        ],
      ),
    );
  }
}
