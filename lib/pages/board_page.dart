import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/pages/transaction_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/offline_user_info_dialog.dart';
import 'package:monopoly/widgets/slot_graphic.dart';
import 'package:monopoly/widgets/slot_information_dialog.dart';
import 'package:provider/provider.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  GlobalKey key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);

    boardProvider.getBlockHeight();

    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => boardProvider.setScroll());

    return ChangeNotifierProvider<SocketProvider>(
      lazy: false,
      create: (context) => SocketProvider(userProvider.user),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Monopoly'),
            elevation: 0.0,
            actions: [
              // InkWell(
              //     onTap: () {
              //       final player = AudioCache();
              //
              //       // call this method when desired
              //       player.play('sounds/rent_paid.wav');
              //
              //     },
              //     child: const Icon(Icons.star)),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LearnMorePage()));
                  },
                  child: const Icon(Icons.info_outlined)),
              const SizedBox(
                width: 10,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TransactionPage()));
                  },
                  child: const Icon(Icons.assignment)),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  controller: boardProvider.scrollController,
                  child: Stack(
                    children: [
                      Consumer3<BoardProvider, UserProvider, SocketProvider>(
                          builder: (context, boardProvider, userProvider,
                              socketProvider, child) {
                        return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            // controller: userProvider.scrollController,
                            itemCount: boardProvider.slots.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        key: boardProvider.slots[index].endKey,
                                        decoration:
                                            SlotGraphic.getBackgroundImage(
                                                boardProvider
                                                    .slots[index].type),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              boardProvider.slots[index]
                                                              .status !=
                                                          null &&
                                                      boardProvider.slots[index]
                                                              .status! ==
                                                          'for_sell'
                                                  ? const Text('(For Sell)',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ))
                                                  : const SizedBox(),
                                              (boardProvider.slots[index]
                                                              .owner !=
                                                          null &&
                                                      boardProvider.slots[index]
                                                              .owner?.id !=
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
                                                builder: (context) =>
                                                    SlotInformationDialog(
                                                        slot: boardProvider
                                                            .slots[index]));
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          tileColor:
                                              boardProvider.slots[index].color,
                                          title: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                    '${boardProvider.slots[index].name} ',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ),
                                              boardProvider.slots[index].type ==
                                                      'chest'
                                                  ? Image.asset(
                                                      'assets/images/chest-pro.png',
                                                      height: 100,
                                                      width: 100,
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                          trailing: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    boardProvider.slots[index]
                                                                    .allStepCount !=
                                                                null &&
                                                            boardProvider
                                                                .slots[index]
                                                                .allStepCount!
                                                                .containsKey(
                                                                    userProvider
                                                                        .user
                                                                        .serverId)
                                                        ? Container(
                                                            height: 20,
                                                            decoration: const BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            12)),
                                                                color: Colors
                                                                    .indigo),
                                                            child: Center(
                                                                child: boardProvider
                                                                            .slots[index]
                                                                            .type ==
                                                                        'reward'
                                                                    ? Row(
                                                                        children: boardProvider.getRewardStars(boardProvider
                                                                            .slots[index]
                                                                            .allStepCount![userProvider.user.serverId]),
                                                                      )
                                                                    : Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                8.0,
                                                                            right:
                                                                                8.0),
                                                                        child: Text(
                                                                            'steps: ${boardProvider.slots[index].allStepCount![userProvider.user.serverId]}',
                                                                            style:
                                                                                const TextStyle(color: Colors.white)),
                                                                      )),
                                                          )
                                                        : const SizedBox(),
                                                    const SizedBox(
                                                      width: 2,
                                                    ),
                                                    socketProvider
                                                                .getOfflineUsers(
                                                                    index) !=
                                                            0
                                                        ? InkWell(
                                                            onTap: () {
                                                              List<User>
                                                                  offlineUsers =
                                                                  socketProvider
                                                                      .getOfflineUserData(
                                                                          index);
                                                              debugPrint(
                                                                  'offline users boardPage ${offlineUsers.first.id}');
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (context) =>
                                                                      OfflineUserInfoDialog(
                                                                          users:
                                                                              offlineUsers));
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                          .indigo[
                                                                      200]),
                                                              child: Center(
                                                                  child: Text(
                                                                      '${socketProvider.getOfflineUsers(index)}',
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.white))),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ]),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // (index == boardProvider.characterIndex &&
                                  (index == userProvider.user.currentSlot &&
                                          boardProvider.isCharacterStatic)
                                      ? Positioned(
                                          key: boardProvider.staticCharacterKey,
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
                      Consumer<BoardProvider>(
                          builder: (context, boardProvider, child) {
                        return boardProvider.isCharacterStatic == false
                            ? AnimatedPositioned(
                                key: boardProvider.characterKey,
                                duration: const Duration(milliseconds: 900),
                                top: boardProvider.characterTop,
                                left: 120,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                ),
                              )
                            : const SizedBox();
                      }),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //TODO: Add according to the top padding
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Consumer<BoardProvider>(
                          builder: (context, boardProvider, child) {
                        return AnimatedOpacity(
                          opacity: boardProvider.showMessageOpacity,
                          duration: const Duration(milliseconds: 2000),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(boardProvider.message),
                                    InkWell(
                                      onTap: () {
                                        boardProvider.hideMessage();
                                      },
                                      child: const Icon(Icons.cancel_outlined),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      }),
                    )
                  ],
                ),
              ],
            ),
          ),
          floatingActionButton: Consumer<SocketProvider>(
              builder: (context, socketProvider, child) {
                return socketProvider.activeMove
                    ? FloatingActionButton(
                  onPressed: () async {
                    socketProvider.disableMove();
                    int diceFace = diceProvider.rollDice();
                    await boardProvider.animateA(diceFace);
                    userProvider.setCurrentSlot(diceFace);
                    userProvider.setCurrentSlotServer(await boardProvider
                        .checkSlotEffect(userProvider.user));
                    socketProvider.updateUserCurrentSlot(userProvider.user);
                    // socketProvider.enableMove();

                    // boardProvider.animate();
                    //userProvider.setCurrentSlot(diceProvider.rollDice());
                    // userProvider.setCurrentSlotServer(await boardProvider
                    //     .checkSlotEffect(userProvider.user));
                    // RenderBox box = key.currentContext?.findRenderObject() as RenderBox;
                    // Offset position = box.localToGlobal(Offset.zero);
                    // debugPrint('position ${position.direction} ${position.dx} ${position.dy}');
                    //  boardProvider.animate();
                    //   socketProvider.updateUserCurrentSlot(userProvider.user);

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
                    : FloatingActionButton(
                  child: Consumer<DiceProvider>(
                      builder: (context, diceProvider, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            diceProvider.face != 0
                                ? Text('${diceProvider.face}',
                                style: const TextStyle(color: Colors.white))
                                : const SizedBox()
                          ],
                        );
                      }),
                  backgroundColor: Colors.pinkAccent,
                  onPressed: () {},
                );
              }),
          bottomNavigationBar: Container(
            height: 20,
            color: Colors.purple,
            child:
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text('Name: ${userProvider.user.id}',
                        style:
                        const TextStyle(color: Colors.white, fontSize: 12)),
                    const SizedBox(),
                    Text(
                      'Credits: ${userProvider.user.credits}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const SizedBox(),
                  ],
                ),
              );
            }),
          )),
    );
  }
}