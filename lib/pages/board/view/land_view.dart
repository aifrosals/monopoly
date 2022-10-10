import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/template_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/user_slot_info_dialog.dart';
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
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
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
                    Row(
                      children: [
                        Stack(
                          children: [
                            Consumer<TemplateProvider>(
                                builder: (context, templateProvider, child) {
                              if (slot.image != null) {
                                return CachedNetworkImage(
                                  imageUrl: slot.image!,
                                  height: 140,
                                  width: 140,
                                );
                              } else if (templateProvider
                                      .templates.isNotEmpty &&
                                  templateProvider.checkLevel(0)) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: CachedNetworkImage(
                                    imageUrl: templateProvider
                                        .getTemplateByLevel(0)
                                        .imageUrl,
                                    height: 140,
                                    width: 140,
                                  ),
                                );
                              } else {
                                return Image.asset(
                                  'assets/images/land.png',
                                  height: 140,
                                  width: 140,
                                );
                              }
                            }),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 28.0, bottom: 8.0, right: 0),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<TemplateProvider>(builder:
                                      (context, templateProvider, child) {
                                    if (templateProvider.templates.isNotEmpty &&
                                        templateProvider.checkLevel(0)) {
                                      return SizedBox(
                                        width: templateProvider
                                                    .getTemplateByLevel(0)
                                                    .name
                                                    .length <=
                                                5
                                            ? 100
                                            : 140,
                                        child: FittedBox(
                                          child: Text(
                                            templateProvider
                                                .getTemplateByLevel(0)
                                                .name,
                                            style: GoogleFonts.teko(
                                                color: Colors.white,
                                                fontSize: 38,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 100,
                                        child: FittedBox(
                                          child: Text(
                                            "Land",
                                            style: GoogleFonts.teko(
                                                color: Colors.white,
                                                fontSize: 30,
                                                height: 0.4,
                                                letterSpacing: 1.5,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                          width: 22,
                                          child: Image.asset(
                                              'assets/images/walking.png')),
                                      const SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        "${slot.allStepCount != null && slot.allStepCount![userProvider.user.serverId] != null ? slot.allStepCount![userProvider.user.serverId] : '0'}",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 7.0,
                                      ),
                                      SizedBox(
                                          width: 22,
                                          child: Image.asset(
                                              'assets/images/dollar.png')),
                                      const SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        '${slot.status == 'for_sell' ? slot.getHalfSellingPrice() : slot.getSellingPrice()}',
                                        style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 7.0,
                                      ),
                                      SizedBox(
                                          width: 22,
                                          child: Image.asset(
                                              'assets/images/payment.png')),
                                      const SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        '${slot.getRent()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
          slot.status == 'for_sell'
              ? Positioned(
              left: 85,
              top: 30,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset('assets/images/for_sale.png', height: 60,),
              ))
              : const SizedBox(),
          slot.owner != null
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              ChangeNotifierProvider<SocketProvider>.value(
                                  value: socketProvider,
                                  child:
                                      UserSlotInfoDialog(owner: slot.owner!)));
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, bottom: 10),
                        child: slot.owner!.profileImageUrl != null
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 22,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: CachedNetworkImageProvider(
                                    slot.owner!.profileImageUrl!,
                                  ),
                                ),
                              )
                            : const CircleAvatar(
                                radius: 22,
                                child: Center(
                                    child: Icon(
                                  CupertinoIcons.person_alt_circle,
                                )),
                              )),
                  ))
              : const SizedBox()
        ],
      ),
    );
  }
}
