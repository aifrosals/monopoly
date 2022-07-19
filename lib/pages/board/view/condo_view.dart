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

class CondoView extends StatelessWidget {
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const CondoView({Key? key,
    this.socketProvider,
    this.boardProvider,
    required this.slot,
    required this.onSlotClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onSlotClick,
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 1.0),
                child: SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      key: slot.endKey,
                      decoration: BoxDecoration(
                          color: slot.color,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12))),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 150,
                              ),
                              Expanded(
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FittedBox(
                                        child: SizedBox(
                                          height: 50,
                                          child: Consumer<TemplateProvider>(
                                              builder: (context,
                                                  templateProvider, child) {
                                            if (templateProvider
                                                    .templates.isNotEmpty &&
                                                templateProvider
                                                    .checkLevel(3)) {
                                              return Text(
                                                templateProvider
                                                    .getTemplateByLevel(3)
                                                    .name,
                                                style: GoogleFonts.teko(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    letterSpacing: 1.5,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            } else {
                                              return Text(
                                                slot.name,
                                                style: GoogleFonts.teko(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    letterSpacing: 1.5,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              );
                                            }
                                          }),
                                        ),
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
                                                      slot.allStepCount![
                                                              userProvider.user
                                                                  .serverId] !=
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Transform.translate(
                                  offset: const Offset(10, -18),
                                  child: Transform.scale(
                                      scale: 1.25,
                                      child: Consumer<TemplateProvider>(builder:
                                          (context, templateProvider, child) {
                                        if (slot.image != null) {
                                          return CachedNetworkImage(
                                            imageUrl: slot.image!,
                                            height: 140,
                                            width: 140,
                                          );
                                        } else if (templateProvider
                                                .templates.isNotEmpty &&
                                            templateProvider.checkLevel(3)) {
                                          return CachedNetworkImage(
                                            imageUrl: templateProvider
                                                .getTemplateByLevel(3)
                                                .imageUrl,
                                            height: 140,
                                            width: 140,
                                          );
                                        } else {
                                          return Image.asset(
                                            'assets/images/condo.png',
                                            height: 140,
                                            width: 140,
                                          );
                                        }
                                      }))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                                      child: UserSlotInfoDialog(
                                          owner: slot.owner!)));
                        },
                        child: Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 10),
                            child: slot.owner!.profileImageUrl != null
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 22,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
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
                  : const SizedBox(),
              slot.status == 'for_sell'
                  ? Positioned.fill(
                      top: 30,
                      child: Transform.translate(
                        offset: Offset(-50, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image.asset(
                            'assets/images/for_sale.png',
                            height: 60,
                          ),
                        ),
                      ))
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
