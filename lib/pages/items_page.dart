import 'package:flutter/material.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatelessWidget {
  const ItemsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Items',
          ),
        ),
        body: Consumer3<UserProvider, BoardProvider, SocketProvider>(builder:
            (context, userProvider, boardProvider, socketProvider, child) {
          return Stack(
            children: [
              Container(
                color: Colors.purple.withOpacity(0.7),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    FittedBox(
                      child: Column(
                        children: [
                          Text(
                            'Step(${userProvider.user.items.step})',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.end,
                          ),
                          boardProvider.isItemEffectActive
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Use',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                  ),
                                  onPressed: () async {
                                    bool res = await boardProvider
                                        .useStep(userProvider.user);
                                    if (res) {
                                      Navigator.pop(context);
                                      int diceFace = diceProvider.getOne();
                                      await boardProvider.animateA(diceFace);
                                      userProvider.setCurrentSlot(diceFace);
                                      userProvider.setCurrentSlotServer(
                                          await boardProvider.checkSlotEffect(
                                              userProvider.user));
                                      socketProvider.updateUserCurrentSlot(
                                          userProvider.user, diceFace);
                                    }
                                  },
                                  child: const Text(
                                    'Use',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    FittedBox(
                      child: Column(
                        children: [
                          Text(
                            'Kick(${userProvider.user.items.kick})',
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.end,
                          ),
                          boardProvider.isItemEffectActive
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                  ),
                                  onPressed: () {},
                                  child: const Text(
                                    'Use',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.amber,
                                  ),
                                  onPressed: () {
                                    boardProvider.kickUser(userProvider.user);
                                  },
                                  child: const Text(
                                    'Use',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                )
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
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
          );
        }));
  }
}
