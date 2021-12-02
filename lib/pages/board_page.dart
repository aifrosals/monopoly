import 'package:flutter/material.dart';
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

    return ChangeNotifierProvider<SocketProvider>(
      lazy: false,
      create: (context) => SocketProvider(userProvider.user),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Consumer<SocketProvider>(
                    builder: (context, socketProvider, child) {
                  return Text(
                      'user offline ${socketProvider.users.map((e) => e.toJson())}');
                }),
                Consumer2<BoardProvider, UserProvider>(
                    builder: (context, boardProvider, userProvider, child) {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      controller: userProvider.scrollController,
                      itemCount: boardProvider.slots.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            SizedBox(
                              height: 70,
                              child: ListTile(
                                tileColor: boardProvider.slots[index].color,
                                title: Text(boardProvider.slots[index].name,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20)),
                              ),
                            ),
                            index == userProvider.user.currentSlot
                                ? Positioned(
                                    left: 120,
                                    top: 15,
                                    child: Container(
                                      height: 30,
                                      width: 30,
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
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Provider.of<UserProvider>(context, listen: false).setCurrentSlot(
                Provider.of<DiceProvider>(context, listen: false).rollDice());
          },
          child:
              Consumer<DiceProvider>(builder: (context, diceProvider, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('dice', style: TextStyle(color: Colors.white)),
                diceProvider.face != 0
                    ? Text('${diceProvider.face}',
                    style: const TextStyle(color: Colors.white))
                    : const SizedBox()
              ],
            );
          }),
          backgroundColor: Colors.pinkAccent,
        ),
      ),
    );
  }
}
