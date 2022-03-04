import 'package:flutter/material.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/pages/transaction_page.dart';
import 'package:monopoly/pages/user_menu_page.dart';
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
                            itemCount: boardProvider.slots.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    height: boardProvider.kSlotHeight,
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
                                          title: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
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
                                                  boardProvider.slots[index]
                                                              .type ==
                                                          'chest'
                                                      ? Image.asset(
                                                          'assets/images/chest-pro.png',
                                                          width: 100,
                                                        )
                                                      : const SizedBox(),
                                                ],
                                              ),
                                              boardProvider.slots[index]
                                                          .initialType ==
                                                      'challenge'
                                                  ? Row(
                                                      children: [
                                                        const CircleAvatar(
                                                          backgroundImage:
                                                              AssetImage(
                                                                  'assets/images/challenge.jpg'),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            child: Container(
                                                              height: 20,
                                                              color:
                                                                  Colors.white,
                                                              child:
                                                                  LinearProgressIndicator(
                                                                value: userProvider
                                                                        .user
                                                                        .challengeProgress /
                                                                    10,
                                                                color: Colors
                                                                    .green,
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  : const SizedBox()
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
                                                              debugPrint(
                                                                  'pressed');
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
                                duration: const Duration(milliseconds: 500),
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
                const SizedBox(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //TODO: Add according to the top padding
                    SizedBox(
                      height: ScreenConfig.paddingTop + 10,
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
                                              boardProvider.isItemEffectAcitve
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
                                              boardProvider.isItemEffectAcitve
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
                            boardProvider.isItemEffectAcitve
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
                })
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
                        Consumer<SocketProvider>(
                            builder: (context, socketProvider, child) {
                          return socketProvider.activeMove
                              ? FloatingActionButton(
                                  onPressed: () async {
                              socketProvider.disableMove();
                              int diceFace = diceProvider.rollDice();
                              await boardProvider.animateA(diceFace);
                              userProvider.setCurrentSlot(diceFace);
                              userProvider.setCurrentSlotServer(
                                  await boardProvider
                                      .checkSlotEffect(userProvider.user));
                              socketProvider.updateUserCurrentSlot(
                                  userProvider.user, diceFace);
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

                              debugPrint(
                                  'user loop count ${userProvider.user.loops}');
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
                                mainAxisAlignment: MainAxisAlignment.center,
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
          ),
          bottomNavigationBar: Container(
            height: 40,
            color: Colors.purple,
            child:
                Consumer<UserProvider>(builder: (context, userProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.white.withOpacity(0.3)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              //  side: const BorderSide(color: Colors.red)
                            ),
                          ),
                        ),
                        onPressed: () {
                          boardProvider.showItemList();
                        },
                        child: Text(
                            'Items(${userProvider.user.getItemCount()})',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 30,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white.withOpacity(0.3)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  //  side: const BorderSide(color: Colors.red)
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const UserMenuPage()));
                            },
                            child: Text(userProvider.user.id,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        userProvider.user.bonus.active
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    '2x',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                  Icon(
                                    Icons.monetization_on_rounded,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          width: 10,
                        ),
                        userProvider.user.shield.active
                            ? const Icon(
                                Icons.shield_rounded,
                                color: Colors.lightBlueAccent,
                                semanticLabel: 'Shield',
                              )
                            : const SizedBox()
                      ],
                    ),
                    Consumer<BoardProvider>(
                        builder: (context, boardProvider, child) {
                      return Text(
                        'Credits: ${userProvider.user.credits}',
                        style: TextStyle(
                            color: boardProvider.isCharacterStatic
                                ? Colors.white
                                : Colors.amber,
                            fontSize: 12),
                      );
                    }),
                    const SizedBox(),
                  ],
                ),
              );
            }),
          )),
    );
  }
}
