import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';

class StartView extends StatelessWidget {
  final UserProvider? userProvider;
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const StartView(
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
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            key: slot.endKey,
            decoration: BoxDecoration(
                color: slot.color.withAlpha(148),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: slot.color,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 16.0),
                      child: Image.asset('assets/images/rocket.png'),
                    ),
                    FittedBox(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Text(
                              "Start Here",
                              style: GoogleFonts.teko(
                                  color: Colors.white,
                                  fontSize: 48,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.money),
                              Text("20 Credits as you pass")
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
