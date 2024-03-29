import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

//TODO: remove end key usage except for end slot
class RewardView extends StatelessWidget {
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const RewardView(
      {Key? key,
      this.socketProvider,
      this.boardProvider,
      required this.slot,
      required this.onSlotClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
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
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                              5,
                                  (index) =>
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.star_border,
                                  size: 33,
                                  color: Colors.yellow,
                                ),
                              )),
                        ),
                      ),
                      slot.allStepCount != null &&
                              slot.allStepCount![userProvider.user.serverId] !=
                                  null
                          ? Align(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                    5,
                                    (index) => index <
                                            slot.allStepCount![
                                                userProvider.user.serverId]
                                        ? const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.star,
                                              size: 33,
                                              color: Colors.yellow,
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: Icon(
                                              Icons.star_border,
                                              size: 33,
                                              color: Colors.yellow,
                                            ),
                                          )),
                              ),
                            )
                          : const SizedBox(),

                      /*    Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding:
                          const EdgeInsets.only(top: 8.0, right: 8.0),
                          child: Image.asset(
                            'assets/images/star.png',
                            scale: 1.2,
                          ),
                        ),
                      ),
                      slot.allStepCount != null && slot.allStepCount![
                      userProvider.user.serverId] != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] >=
                              1
                          ? Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 8.0),
                          child: Image.asset(
                                  'assets/images/star.png',
                                  scale: 1.2,
                                ),
                              ),
                            )
                          : const Positioned(
                              top: 0, left: 0, child: SizedBox()),
                      Positioned(
                        top: 35,
                        left: 35,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 8.0, right: 8.0),
                          child: Image.asset(
                            'assets/images/star.png',
                            scale: 1.2,
                          ),
                        ),
                      ),
                      slot.allStepCount != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] >=
                              2
                          ? Positioned(
                              top: 35,
                              left: 35,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, right: 8.0),
                                child: Image.asset(
                                  'assets/images/star.png',
                                  scale: 1.2,
                                ),
                              ),
                            )
                          : const Positioned(
                              top: 35, left: 35, child: SizedBox()),
                      Positioned(
                        top: 6,
                        left: 70,
                        child: Image.asset(
                          'assets/images/star.png',
                          scale: 0.8,
                        ),
                      ),
                      slot.allStepCount != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] >=
                              3
                          ? Positioned(
                              top: 6,
                              left: 70,
                              child: Image.asset(
                                'assets/images/star.png',
                                scale: 0.8,
                              ),
                            )
                          : const Positioned(
                              top: 6, left: 70, child: SizedBox()),
                      Positioned(
                        top: 1,
                        left: 133,
                        child: Image.asset(
                          'assets/images/star.png',
                          scale: 1.2,
                        ),
                      ),
                      slot.allStepCount != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] >=
                              4
                          ? Positioned(
                              top: 1,
                              left: 133,
                              child: Image.asset(
                                'assets/images/star.png',
                                scale: 1.2,
                              ),
                            )
                          : const Positioned(
                              top: 1, left: 133, child: SizedBox()),
                      Positioned(
                        top: 25,
                        left: 170,
                        child: Image.asset(
                          'assets/images/star.png',
                          scale: 0.8,
                        ),
                      ),
                      slot.allStepCount != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] != null &&
                          slot.allStepCount![
                          userProvider.user.serverId] >=
                              5
                          ? Positioned(
                              top: 25,
                              left: 170,
                              child: Image.asset(
                                'assets/images/star.png',
                                scale: 0.8,
                              ),
                            )
                          : const Positioned(
                              top: 25, left: 170, child: SizedBox()),*/
                    ],
                  ),
                  Text(
                    slot.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.teko(
                      color: Colors.white,
                      fontSize: 30,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
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
