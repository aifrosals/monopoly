import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';

class ChestView extends StatelessWidget {
  final UserProvider? userProvider;
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const ChestView(
      {Key? key,
      this.userProvider,
      this.socketProvider,
      this.boardProvider,
      required this.slot,
      required this.onSlotClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSlotClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
        child: Stack(
          children: [
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  key: slot.endKey,
                  decoration: BoxDecoration(
                      color: slot.color.withAlpha(148),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: slot.color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16.0,
                          ),
                          SizedBox(
                              width: 180,
                              child: FittedBox(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 55,
                                      child: Text(
                                        slot.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 48,
                                            color: Colors.white),
                                      )),
                                ],
                              ))),
                          const Spacer(),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, right: 20.0),
                            child:
                                Image.asset('assets/images/treasure_chest.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
