import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';

class LandView extends StatelessWidget {
  final UserProvider? userProvider;
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const LandView(
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
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                  color: slot.color,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Image.asset('assets/images/land.png'),
                      slot.status == 'for_sell'
                          ? Positioned.fill(
                              child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset('assets/images/for_sale.png'),
                            ))
                          : const SizedBox()
                    ],
                  ),
                  Expanded(
                    child: FittedBox(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(
                              height: 50,
                              child: Text(
                                "For Sell",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                    width: 32,
                                    child: Image.asset(
                                        'assets/images/dollar.png')),
                                SizedBox(
                                  width: 8.0,
                                ),
                                const Text(
                                  "12",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
