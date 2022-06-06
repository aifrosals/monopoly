import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/pages/items_page.dart';
import 'package:monopoly/pages/user_menu_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/drawer.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:monopoly/widgets/offline_user_info_dialog.dart';
import 'package:monopoly/widgets/slot_graphic.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) =>
        boardProvider.setScroll());

    return ChangeNotifierProvider<SocketProvider>(
      lazy: false,
      create: (context) => SocketProvider(userProvider.user),
      child: Scaffold(
        drawer: const MonopolyDrawer(),
        appBar: AppBar(
          title:
          Consumer<UserProvider>(builder: (context, userProvider, child) {
            return FittedBox(child: Text('Hi ${userProvider.user.id}'));
            }),
            elevation: 0.0,
            actions: [
              Consumer<SocketProvider>(
                  builder: (context, socketProvider, child) {
                return SizedBox(
                  height: 30,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.white.withOpacity(0.3)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          //  side: const BorderSide(color: Colors.red)
                        ),
                      ),
                    ),
                    onPressed: () {
                      // boardProvider.showItemList();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChangeNotifierProvider<SocketProvider>.value(
                                      value: socketProvider,
                                      child: const ItemsPage())));
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/images/items.png'),
                        Text('(${userProvider.user.getItemCount()})',
                            style: const TextStyle(
                                fontSize: 8, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(
                height: 30,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserMenuPage()));
                  },
                  child: const Icon(
                    CupertinoIcons.person_alt_circle,
                    color: Colors.black,
                  ),
                ),
              ),
              Consumer<BoardProvider>(builder: (context, boardProvider, child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.attach_money),
                          Text(
                            '${userProvider.user.credits}',
                            style: TextStyle(
                                color: boardProvider.isCharacterStatic
                                    ? Colors.black
                                    : Colors.amber,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
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
                                itemCount: boardProvider.slots.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Stack(

                                    children: [

                                      SizedBox(
                                        height: boardProvider.kSlotHeight,
                                        child: SlotGraphic.getSlotWidget(
                                            boardProvider.slots[index]),
                                      ),

                                      socketProvider.getOfflineUsers(index) != 0
                                          ? Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            debugPrint('pressed');
                                            List<User> offlineUsers =
                                            socketProvider
                                                .getOfflineUserData(
                                                index);
                                            debugPrint(
                                                'offline users boardPage ${offlineUsers
                                                    .first.id}');
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    OfflineUserInfoDialog(
                                                        users:
                                                        offlineUsers));
                                          },
                                          child: SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: Center(
                                                child: Text(
                                                    '${socketProvider
                                                        .getOfflineUsers(
                                                        index)}',
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
                                        key: boardProvider
                                            .staticCharacterKey,
                                        right: 40,
                                        top: 15,
                                        child: Container(
                                          height: 25,
                                          width: 25,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/pawn.png')),
                                              shape: BoxShape.circle,
                                              color: Colors.lightGreen),
                                        ),
                                      )
                                          : const SizedBox(),

                                      Positioned(
                                          left: 10,
                                          top: 9,
                                          child: Text('${index + 1}',
                                              style: const TextStyle(
                                                  color: Colors.white))),
                                    ],
                                  );
                                });
                    }),
                      Consumer<BoardProvider>(
                          builder: (context, boardProvider, child) {
                        return boardProvider.isCharacterStatic == false
                            ? AnimatedPositioned(
                          key: boardProvider.characterKey,
                          duration: const Duration(milliseconds: 500),
                          top: boardProvider.characterTop,
                          right: 40,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 1000),
                            height: boardProvider.characterHeight,
                            width: boardProvider.characterWidth,
                            decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage(
                                    'assets/images/pawn.png'),),
                                shape: BoxShape.circle,
                                color: Colors.blue),
                          ),
                              )
                            : const SizedBox();
                      }),
                    ],
                  ),
                ),

                // Column(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     //TODO: Add according to the top padding
                //     SizedBox(
                //       height: ScreenConfig.paddingTop + 10,
                //     ),
                //     Align(
                //       alignment: Alignment.center,
                //       child: Consumer<BoardProvider>(
                //           builder: (context, boardProvider, child) {
                //             return AnimatedOpacity(
                //               opacity: boardProvider.showMessageOpacity,
                //               duration: const Duration(milliseconds: 2000),
                //               child: Container(
                //                   decoration: BoxDecoration(
                //                       color: Colors.white.withOpacity(0.8)),
                //                   child: Padding(
                //                     padding: const EdgeInsets.all(8.0),
                //                     child: Row(
                //                       mainAxisAlignment:
                //                       MainAxisAlignment.spaceBetween,
                //                       children: [
                //                         Text(boardProvider.message),
                //                         InkWell(
                //                           onTap: () {
                //                             boardProvider.hideMessage();
                //                           },
                //                           child: const Icon(Icons.cancel_outlined),
                //                         ),
                //                       ],
                //                     ),
                //                   )),
                //             );
                //           }),
                //     )
                //   ],
                // ),
                Consumer3<UserProvider, BoardProvider, SocketProvider>(builder:
                    (context, userProvider, boardProvider, socketProvider,
                        child) {
                  return boardProvider.isItemListVisible
                      ? Positioned(
                          bottom: 5,
                          left: 40,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: 120,
                                  width: 150,
                                  color: Colors.purple.withOpacity(0.7),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Step(${userProvider.user.items.step})',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              boardProvider.isItemEffectActive
                                                  ? ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.amber,
                                                      ),
                                                      onPressed: () {},
                                                      child: const Text(
                                                        'Use',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    )
                                                  : ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.amber,
                                                      ),
                                                      onPressed: () async {
                                                        bool res =
                                                            await boardProvider
                                                                .useStep(
                                                                    userProvider
                                                                        .user);
                                                        if (res) {
                                                          int diceFace =
                                                              diceProvider
                                                                  .getOne();
                                                          await boardProvider
                                                              .animateA(
                                                                  diceFace);
                                                          userProvider
                                                              .setCurrentSlot(
                                                                  diceFace);
                                                          userProvider.setCurrentSlotServer(
                                                              await boardProvider
                                                                  .checkSlotEffect(
                                                                      userProvider
                                                                          .user));
                                                          socketProvider
                                                              .updateUserCurrentSlot(
                                                                  userProvider
                                                                      .user,
                                                                  diceFace);
                                                        }
                                                      },
                                                      child: const Text(
                                                        'Use',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                      ),
                                      Expanded(
                                        child: FittedBox(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Kick(${userProvider.user.items.kick})',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              boardProvider.isItemEffectActive
                                                  ? ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.amber,
                                                      ),
                                                      onPressed: () {},
                                                      child: const Text(
                                                        'Use',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    )
                                                  : ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary: Colors.amber,
                                                      ),
                                                      onPressed: () {
                                                        boardProvider.kickUser(
                                                            userProvider.user);
                                                      },
                                                      child: const Text(
                                                        'Use',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.end,
                                                      ),
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    boardProvider.hideItemList();
                                  },
                                  child: const Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  )),
                              boardProvider.isItemEffectActive
                                  ? const Positioned(
                                      right: 0,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ))
                                : const SizedBox()
                          ],
                        ),
                      )
                    : const SizedBox();
              }),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 28.0, right: 178.0, bottom: 2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Card(
                                  color: Colors.pink.shade300,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: FittedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: userProvider.user.bonus.active
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Text(
                                                    '2x',
                                                    style: TextStyle(
                                                        color: Colors.yellow),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .monetization_on_rounded,
                                                    color: Colors.yellow,
                                                    size: 20,
                                                  ),
                                                ],
                                              )
                                            : Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: const [
                                                  Center(
                                                    child: Text(
                                                      '2x',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Icon(
                                                      Icons
                                                          .monetization_on_rounded,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Card(
                                  color: Colors.pink.shade300,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: FittedBox(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: userProvider.user.shield.active
                                              ? const Icon(
                                                  Icons.shield_rounded,
                                                  color: Colors.lightBlueAccent,
                                                  semanticLabel: 'Shield',
                                                )
                                              : const Icon(
                                                  Icons.shield_rounded,
                                                  color: Colors.white,
                                                  semanticLabel: 'Shield',
                                                )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(),
                            // CountdownTimer(
                            //   endTime: userProvider.user.getDiceTime(),
                            // ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
            ),
          ),
          floatingActionButton: userProvider.user.id == 'user3'
              ? SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<SocketProvider>(
                            builder: (context, socketProvider, child) {
                          return socketProvider.activeMove
                              ? FloatingActionButton(
                                  heroTag: 'u3',
                                  onPressed: () async {
                                    socketProvider.disableMove();

                                    userProvider.setPreviousSlot();
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));
                                    await boardProvider.setScroll();
                                    socketProvider.moveBack(userProvider.user);
                                  },
                                  child: Consumer<DiceProvider>(
                                      builder: (context, diceProvider, child) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('Back',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        diceProvider.face != 0
                                            ? Text('${diceProvider.face}',
                                                style: const TextStyle(
                                                    color: Colors.white))
                                            : const SizedBox()
                                      ],
                                    );
                                  }),
                                  backgroundColor: Colors.pinkAccent,
                                )
                              : FloatingActionButton(
                                  heroTag: 'u3f',
                                  child: Consumer<DiceProvider>(
                                      builder: (context, diceProvider, child) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        diceProvider.face != 0
                                            ? Text('${diceProvider.face}',
                                                style: const TextStyle(
                                                    color: Colors.white))
                                            : const SizedBox()
                                      ],
                                    );
                                  }),
                                  backgroundColor: Colors.pinkAccent,
                                  onPressed: () {},
                                );
                        }),
                        Consumer<SocketProvider>(
                            builder: (context, socketProvider, child) {
                          return socketProvider.activeMove
                              ? FloatingActionButton(
                                  onPressed: () async {
                                    socketProvider.disableMove();
                                    int diceFace = diceProvider.getOne();
                                    await boardProvider.animateA(diceFace);
                                    userProvider.setCurrentSlot(diceFace);
                                    userProvider.setCurrentSlotServer(
                                        await boardProvider.checkSlotEffect(
                                            userProvider.user));
                                    socketProvider.updateUserCurrentSlot(
                                        userProvider.user, diceFace);
                                    debugPrint(
                                        'user loop count ${userProvider.user.loops}');
                                  },
                                  child: Consumer<DiceProvider>(
                                      builder: (context, diceProvider, child) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text('dice',
                                            style:
                                                TextStyle(color: Colors.white)),
                                        diceProvider.face != 0
                                            ? Text('${diceProvider.face}',
                                                style: const TextStyle(
                                                    color: Colors.white))
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        diceProvider.face != 0
                                            ? Text('${diceProvider.face}',
                                                style: const TextStyle(
                                                    color: Colors.white))
                                            : const SizedBox()
                                      ],
                                    );
                                  }),
                                  backgroundColor: Colors.pinkAccent,
                                  onPressed: () {},
                                );
                        }),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      Consumer2<SocketProvider, UserProvider>(builder:
                          (context, socketProvider, userProvider, child) {
                        return socketProvider.activeMove
                            ? SizedBox(
                                height: 100,
                                width: 100,
                                child: FloatingActionButton(
                                  onPressed: () async {
                                    if (!((userProvider.user.dice ?? 0) <= 0)) {
                                      socketProvider.disableMove();
                                      final player = AudioCache();
                                      player.play('sounds/dice_roll.mp3');
                                        int diceFace = diceProvider.rollDice();
                                        await boardProvider.animateA(diceFace);
                                        userProvider.setCurrentSlot(diceFace);
                                        userProvider.setCurrentSlotServer(
                                            await boardProvider.checkSlotEffect(
                                                userProvider.user));
                                        socketProvider.updateUserCurrentSlot(
                                            userProvider.user, diceFace);

                                        debugPrint(
                                            'user loop count ${userProvider.user.loops}');
                                      } else {
                                        HelpingDialog.showServerResponseDialog(
                                            'You do not have dices');
                                      }
                                    },
                                    child:
                                        Consumer2<UserProvider, DiceProvider>(
                                            builder: (context, userProvider,
                                                diceProvider, child) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Text('dice${diceProvider.face != 0
                                          //     ? ': ${diceProvider.face}'
                                          //     : ''}',
                                          //     style: const TextStyle(
                                        //         color: Colors.white)),
                                        SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: RiveAnimation.asset(
                                              'assets/animations/dice.riv',
                                              animations: [
                                                'sFace${diceProvider.face}'
                                              ],
                                            )),
                                        SizedBox(
                                          height: 20,
                                          width: 40,
                                          child: FittedBox(
                                            child: (userProvider.user.dice ==
                                                        0 &&
                                                    userProvider.user
                                                            .getDiceTime() !=
                                                        0)
                                                ? CountdownTimer(
                                                    endTime: userProvider.user
                                                        .getDiceTime(),
                                                    textStyle: const TextStyle(
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    userProvider.user
                                                        .getDiceString(),
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                          ),
                                        )
                                      ],
                                      );
                                    }),
                                    backgroundColor: Colors.pinkAccent,
                                  ),
                                )
                              : SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: FloatingActionButton(
                                    child: Consumer<DiceProvider>(builder:
                                        (context, diceProvider, child) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // diceProvider.face != 0
                                          //     ? Text('${diceProvider.face}',
                                          //     style: const TextStyle(
                                          //         color: Colors.white))
                                          //     : const SizedBox()
                                          SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: RiveAnimation.asset(
                                                'assets/animations/dice.riv',
                                                animations: [
                                                  'face${diceProvider.face}'
                                                ],
                                              ))
                                        ],
                                      );
                                  }),
                                  backgroundColor: Colors.pinkAccent,
                                  onPressed: () {},
                                ),
                              );
                      }),
                    ],
                  ),
                ),
              ),
        // bottomNavigationBar: Theme(
        //   data: ThemeData(scaffoldBackgroundColor: Colors.green),
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 28.0, right: 28.0),
        //     child: ClipRRect(
        //       borderRadius: BorderRadius.circular(25),
        //       child: Container(
        //         height: 40,
        //         color: Colors.purple,
        //         child:
        //             Consumer<UserProvider>(builder: (context, userProvider, child) {
        //           return Padding(
        //             padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 const SizedBox(),
        //                 Row(
        //                   mainAxisSize: MainAxisSize.min,
        //                   children: [
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     userProvider.user.bonus.active
        //                         ? Row(
        //                             mainAxisSize: MainAxisSize.min,
        //                             children: const [
        //                               Text(
        //                                 '2x',
        //                                 style: TextStyle(color: Colors.yellow),
        //                               ),
        //                               Icon(
        //                                 Icons.monetization_on_rounded,
        //                                 color: Colors.yellow,
        //                                 size: 20,
        //                               ),
        //                             ],
        //                           )
        //                         : const SizedBox(),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     userProvider.user.shield.active
        //                         ? const Icon(
        //                             Icons.shield_rounded,
        //                             color: Colors.lightBlueAccent,
        //                             semanticLabel: 'Shield',
        //                           )
        //                         : const SizedBox()
        //                   ],
        //                 ),
        //                 const SizedBox(),
        //                 // CountdownTimer(
        //                 //   endTime: userProvider.user.getDiceTime(),
        //                 // ),
        //               ],
        //             ),
        //           );
        //         }),
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
