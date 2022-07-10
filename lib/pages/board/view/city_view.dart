import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:monopoly/providers/template_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CityView extends StatelessWidget {
  final BoardProvider? boardProvider;
  final SocketProvider? socketProvider;
  final Slot slot;
  final Function() onSlotClick;

  const CityView({Key? key,
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
                      left: 120,
                      child: Text(
                        'owned by ${slot.owner!.id}',
                        style: TextStyle(color: Colors.white),
                      ))
                      : const SizedBox(),
                  Row(
                    children: [
                      SizedBox(
                          width: 180,
                          child: Stack(
                            children: [
                              Consumer<TemplateProvider>(
                                  builder: (context, templateProvider, child) {
                                if (templateProvider.templates.isNotEmpty &&
                                    templateProvider.checkLevel(5)) {
                                  return CachedNetworkImage(
                                      imageUrl: templateProvider
                                          .getTemplateByLevel(5)
                                          .imageUrl);
                                } else {
                                  return Image.asset('assets/images/city.png');
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
                          )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 55,
                                child: FittedBox(
                                  child: Consumer<TemplateProvider>(builder:
                                      (context, templateProvider, child) {
                                    if (templateProvider.templates.isNotEmpty &&
                                        templateProvider.checkLevel(5)) {
                                      return Text(
                                        templateProvider
                                            .getTemplateByLevel(5)
                                            .name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold),
                                      );
                                    } else {
                                      return Text(
                                        slot.name,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 48,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                  }),
                                ),
                              ),
                              Padding(
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
                              )
                            ],
                          ),
                        ),
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
