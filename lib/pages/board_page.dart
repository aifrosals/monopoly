import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BoardPage extends StatelessWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);

    return ChangeNotifierProvider<SocketProvider>(
      lazy: false,
      create: (context) => SocketProvider(userProvider.user),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Monopoly'),
            elevation: 0.0,
            backgroundColor: Colors.grey[200],
            actions: [
              InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Request to buy your property')
                                  ],
                                ),
                              ),
                            ));
                  },
                  child: const Icon(Icons.notifications))
            ],
          ),
          body: SafeArea(
            child: Consumer3<BoardProvider, UserProvider, SocketProvider>(
                builder: (context, boardProvider, userProvider, socketProvider,
                    child) {
              return ListView.builder(
                  shrinkWrap: true,
                  controller: userProvider.scrollController,
                  itemCount: boardProvider.slots.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        SizedBox(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ListTile(
                              leading: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                              subtitle: (boardProvider.slots[index].owner !=
                                          null &&
                                      boardProvider.slots[index].owner?.id !=
                                          null)
                                  ? Text(
                                      ' bought by ${boardProvider.slots[index].owner?.id}',
                                      style:
                                          const TextStyle(color: Colors.white))
                                  : const SizedBox(),
                              onTap: () {
                                List<User> offlineUsers =
                                socketProvider.getOfflineUserData(index);
                                showDialog(
                                    context: context,
                                    builder: (context) => Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'Offline Users',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              Column(
                                                mainAxisSize:
                                                MainAxisSize.min,
                                                children: offlineUsers
                                                    .map((e) => Text(e.id))
                                                    .toList(),
                                              )
                                            ]),
                                      ),
                                    ));
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              tileColor: boardProvider.slots[index].color,
                              title: Text(boardProvider.slots[index].name,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // boardProvider.slots[index].status != null &&
                                  //         boardProvider.slots[index].status! ==
                                  //             'for_sell'
                                  //     ? const Icon(
                                  //         Icons.star,
                                  //         color: Colors.yellow,
                                  //         size: 15,
                                  //       )
                                  //     : const SizedBox(),
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
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0),
                                                child: Text(
                                                    'steps: ${boardProvider.slots[index].allStepCount![userProvider.user.serverId]}',
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              )),
                                        )
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        socketProvider.getOfflineUsers(index) !=
                                            0
                                            ? Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.indigo[200]),
                                          child: Center(
                                              child: Text(
                                                  '${socketProvider.getOfflineUsers(index)}',
                                                  style: const TextStyle(
                                                      color:
                                                      Colors.white))),
                                        )
                                            : const SizedBox(),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        index == userProvider.user.currentSlot
                            ? Positioned(
                                left: 120,
                                top: 15,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.lightGreen),
                                ),
                              )
                            : const SizedBox()
                      ],
                    );
                  });
            }),
          ),
          floatingActionButton: Consumer<SocketProvider>(
              builder: (context, socketProvider, child) {
            return socketProvider.activeMove
                ? FloatingActionButton(
                    onPressed: () {
                      userProvider.setCurrentSlot(diceProvider.rollDice());
                      socketProvider.updateUserCurrentSlot(userProvider.user);
                      debugPrint('user loop count ${userProvider.user.loops}');
                    },
                    child: Consumer<DiceProvider>(
                        builder: (context, diceProvider, child) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('dice',
                              style: TextStyle(color: Colors.white)),
                          diceProvider.face != 0
                              ? Text('${diceProvider.face}',
                                  style: const TextStyle(color: Colors.white))
                              : const SizedBox()
                        ],
                      );
                    }),
                    backgroundColor: Colors.pinkAccent,
                  )
                : const SizedBox();
          }),
          bottomNavigationBar: Container(
            height: 20,
            color: Colors.purple,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<UserProvider>(
                      builder: (context, userProvider, child) {
                    return Text(
                      'Credits: ${userProvider.user.credits}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  })
                ],
              )
            ]),
          )),
    );
  }
}
