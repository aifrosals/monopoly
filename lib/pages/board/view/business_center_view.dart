import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/template_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class BusinessCenterView extends StatelessWidget {
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const BusinessCenterView({Key? key,
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
                  borderRadius: const BorderRadius.all(Radius.circular(12))),
              child: Stack(
                children: [
                  slot.owner != null
                      ? Positioned(
                      right: 0,
                      left: 140,
                      child: Text(
                        'owned by ${slot.owner!.id}',
                        style: const TextStyle(color: Colors.white),
                      ))
                      : const SizedBox(),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Transform.translate(
                              offset: const Offset(8, -13),
                              child: Transform.scale(
                                  scale: 1.35,
                                  child: Consumer<TemplateProvider>(builder:
                                      (context, templateProvider, child) {
                                    if (templateProvider.templates.isNotEmpty &&
                                        templateProvider.checkLevel(4)) {
                                      return CachedNetworkImage(
                                        imageUrl: templateProvider
                                            .getTemplateByLevel(4)
                                            .imageUrl,
                                        height: 140,
                                        width: 140,
                                      );
                                    } else {
                                      return Image.asset(
                                        'assets/images/business_center.png',
                                        height: 140,
                                        width: 140,
                                      );
                                    }
                                  }))),
                          slot.status == 'for_sell'
                              ? Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  'assets/images/for_sale.png',
                                ),
                              ))
                              : const SizedBox()
                        ],
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FittedBox(
                              child: Consumer<TemplateProvider>(
                                  builder: (context, templateProvider, child) {
                                if (templateProvider.templates.isNotEmpty &&
                                    templateProvider.checkLevel(4)) {
                                  return Text(
                                    templateProvider.getTemplateByLevel(4).name,
                                    style: GoogleFonts.teko(
                                      color: Colors.white,
                                      fontSize: 38,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                } else {
                                  return Text(
                                    slot.name,
                                    style: GoogleFonts.teko(
                                      color: Colors.white,
                                      fontSize: 38,
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }
                              }),
                            ),
                            FittedBox(
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
                                                fontWeight: FontWeight.bold),
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
                      const SizedBox(
                        width: 60,
                      ),
                    ],
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
