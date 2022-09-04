import 'package:flutter/material.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/offline_user_info_dialog.dart';
import 'package:monopoly/widgets/slot_graphic.dart';
import 'package:monopoly/widgets/slot_information_dialog.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserPropertyPage extends StatelessWidget {
  const UserPropertyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Properties'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Consumer2<BoardProvider, SocketProvider>(builder: (context, boardProvider, socketProvider, child) {
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
                      return Stack(
                        children: [
                          SizedBox(
                            key: boardProvider.slots[index].slotKey,
                            height: boardProvider.kSlotHeight,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 13.0, right: 5),
                              child: SlotGraphic.getSlotWidget(
                                  boardProvider.slots[index]),
                            ),
                          ),

                          socketProvider.getOfflineUsers(index) != 0
                              ? Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                              onTap: () {
                                debugPrint('pressed');
                                List<User> offlineUsers =
                                socketProvider
                                    .getOfflineUserData(index);
                                debugPrint(
                                    'offline users boardPage ${offlineUsers.first.id}');
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        OfflineUserInfoDialog(
                                            users: offlineUsers));
                              },
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(
                                    child: Text(
                                        '${socketProvider.getOfflineUsers(index)}',
                                        style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color: Colors.white
                                                .withOpacity(
                                                0.4)))),
                              ),
                            ),
                          )
                              : const SizedBox(),
                          // (index == boardProvider.characterIndex &&
                          (index == userProvider.user.currentSlot &&
                              boardProvider.isCharacterStatic)
                              ? Positioned(
                            key: boardProvider.staticCharacterKey,
                            right: 1,
                            top: 0,
                            child: Container(
                              height: boardProvider.characterHeight,
                              width: boardProvider.characterWidth,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    // image: userProvider.user
                                    //             .tokenImageUrl !=
                                    //         null
                                    //     ? CachedNetworkImageProvider(
                                    //             userProvider.user
                                    //                 .tokenImageUrl!)
                                    //         as ImageProvider
                                    //     :
                                      image: AssetImage(
                                          'assets/images/cone.png')),
                                  color: Colors.transparent),
                            ),
                          )
                              : const SizedBox(),

                          Positioned.fill(
                              left: 3.5,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: RotatedBox(
                                  quarterTurns: -1,
                                  child: Text('${index + 1}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial',
                                          fontSize: 12.3,
                                          letterSpacing: 10,
                                          color: Colors.grey)),
                                ),
                              )),
                        ],
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
