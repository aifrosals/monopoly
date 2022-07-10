import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/template_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LandView extends StatelessWidget {
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const LandView({Key? key,
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
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                decoration: BoxDecoration(
                    color: slot.color,
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Stack(
                  children: [
                    slot.owner != null
                        ? Positioned(
                        right: 0,
                        left: 120,
                        child: Text(
                          'owned by ${slot.owner!.id}',
                          style: TextStyle(color: Colors.white),
                        ))
                        : const SizedBox(),
                    Row(
                      children: [
                        Stack(
                          children: [
                            Consumer<TemplateProvider>(
                                builder: (context, templateProvider, child) {
                              if (templateProvider.templates.isNotEmpty &&
                                  templateProvider.checkLevel(0)) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl: templateProvider
                                        .getTemplateByLevel(0)
                                        .imageUrl,
                                  ),
                                );
                              } else {
                                return Image.asset('assets/images/land.png');
                              }
                            }),
                            slot.status == 'for_sell'
                                ? Positioned.fill(
                                    child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                        'assets/images/for_sale.png'),
                                  ))
                                : const SizedBox()
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                    child: Consumer<TemplateProvider>(builder:
                                        (context, templateProvider, child) {
                                      if (templateProvider
                                              .templates.isNotEmpty &&
                                          templateProvider.checkLevel(0)) {
                                        return Text(
                                          templateProvider
                                              .getTemplateByLevel(0)
                                              .name,
                                          style: GoogleFonts.teko(
                                              color: Colors.white,
                                              fontSize: 38,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700),
                                        );
                                      } else {
                                        return Text(
                                          "For Sell",
                                          style: GoogleFonts.teko(
                                              color: Colors.white,
                                              fontSize: 40,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w700),
                                        );
                                      }
                                    }),
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -17),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                            width: 25,
                                            child: Image.asset(
                                                'assets/images/walking.png')),
                                        const SizedBox(
                                          width: 3.0,
                                        ),
                                        slot.allStepCount != null &&
                                                slot.allStepCount![userProvider
                                                        .user.serverId] !=
                                                    null
                                            ? Text(
                                                "${slot.allStepCount![userProvider.user.serverId]}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : const SizedBox(),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        SizedBox(
                                            width: 25,
                                            child: Image.asset(
                                                'assets/images/dollar.png')),
                                        const SizedBox(
                                          width: 3.0,
                                        ),
                                        Text(
                                          '${slot.status == 'for_sell' ? slot.getHalfSellingPrice() : slot.getSellingPrice()}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 12.0,
                                        ),
                                        SizedBox(
                                            width: 25,
                                            child: Image.asset(
                                                'assets/images/payment.png')),
                                        const SizedBox(
                                          width: 3.0,
                                        ),
                                        Text(
                                          '${slot.getRent()}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
