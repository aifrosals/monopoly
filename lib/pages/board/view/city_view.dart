import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';

class CityView extends StatelessWidget {
  final UserProvider? userProvider;
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const CityView(
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
              key: slot.endKey,
              decoration: BoxDecoration(
                  color: slot.color,
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Row(
                children: [
                  SizedBox(
                      width: 180,
                      child: Stack(
                        children: [
                          Image.asset('assets/images/city.png'),
                          slot.status == 'for_sell'
                              ? Positioned.fill(
                                  child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child:
                                      Image.asset('assets/images/for_sale.png'),
                                ))
                              : const SizedBox()
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                  FittedBox(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 55,
                            child: Text(
                              slot.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                  width: 32,
                                  child: Image.asset('assets/images/buy.png')),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text(
                                "40",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                              const SizedBox(
                                width: 32.0,
                              ),
                              SizedBox(
                                  width: 32,
                                  child:
                                      Image.asset('assets/images/payment.png')),
                              const SizedBox(
                                width: 8.0,
                              ),
                              const Text(
                                "2",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 22),
                              ),
                            ],
                          )
                        ],
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
