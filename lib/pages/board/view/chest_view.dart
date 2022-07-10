import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                                    height: 30,
                                    child: Text(
                                      'Community',
                                      style: GoogleFonts.teko(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Chest',
                                    style: GoogleFonts.teko(
                                      fontSize: 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
