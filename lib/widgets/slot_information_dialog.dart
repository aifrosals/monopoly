import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/slot_graphic.dart';
import 'package:provider/provider.dart';

class SlotInformationDialog extends StatelessWidget {
  final Slot slot;

  const SlotInformationDialog({Key? key, required this.slot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        SlotGraphic.getBackgroundImage(slot.type),
                        height: 190,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        //TODO: change the name according to the template
                        slot.name,
                        style: GoogleFonts.teko(
                            fontSize: 34, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LearnMorePage()));
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.grey[300],
                          child: const Center(
                              child: Icon(
                            Icons.question_mark,
                            size: 10,
                          )),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  slotInfo(slot, userProvider.user),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show information of the slot related to the type
  /// and buying status
  Widget slotInfo(Slot slot, User user) {
    switch (slot.initialType) {
      case 'land':
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
          (slot.owner != null && slot.owner!.serverId == user.serverId) ?
              Column(children: [
            const Text(
              'Owned by you',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            slot.owner!.profileImageUrl != null
                ? SizedBox(
                height: 50,
                width: 50,
                child: CachedNetworkImage(
                    imageUrl: slot.owner!.profileImageUrl!))
                : const Icon(
              CupertinoIcons.person_alt_circle,
              color: Colors.black,
            )
              ],)
                : const SizedBox(),

     (slot.owner != null && slot.owner!.serverId != user.serverId) ?
    Column(
    children: [
    Text(
      'Owned by ${slot.owner!.id}',
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    slot.owner!.profileImageUrl != null
        ? SizedBox(
            height: 50,
            width: 50,
            child: CachedNetworkImage(
                imageUrl: slot.owner!.profileImageUrl!))
        : const Icon(
            CupertinoIcons.person_alt_circle,
            color: Colors.black,
          ),
              ],) : const SizedBox(),

              slot.level! > 0 ? Text('Level: ${slot.level}') : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(left: 70.0),
                child: Column(
                  children: [
                    getPropertyStatusInfo(slot, user),
                    slot.status == 'for_sell'
                        ? Column(
                            children: [
                              Table(
                                children: [
                                  TableRow(
                                  children: [
                                    const Text('For Urgent Sell:'),
                                    Row(
                                      children: [
                                        Text('   '),
                                        const SizedBox(width: 5,),
                                        Image.asset(
                                            'assets/images/for_sale.png', height: 25, width: 25,),
                                      ],
                                    ),

                                  ],
                                ),
                                  TableRow(
                                    children: [
                                      Text(
                                          'Discounted Price:'),
                                      Row(
                                        children: [
                                          Text('${slot.getHalfSellingPrice()}'),
                                          const SizedBox(width: 5,),

                                          Image.asset('assets/images/dollar.png', height: 25, width: 25,),
                                        ],
                                      ),
                                    ],
                                  ),
    ]
                              ),
                            ],
                          )
                        :

                    Table(
                      children: [
                        TableRow(
                          children: [
                            Text('Selling Price:'),
                            Row(
                              children: [
                                Text(slot.getSellingPrice().toString()),
                                const SizedBox(width: 5,),
                                Image.asset('assets/images/dollar.png', width: 25, height: 25,),
                              ],
                            ),
                          ]
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      case 'start':
        {
          return const Text(
            'This is the starting point of the game',
            textAlign: TextAlign.center,
          );
        }
      case 'end':
        {
          return const Text(
              'This is the end point of the slot. On your next dice roll you will be going from the Start again. If you will step on this, you will get 150 credits, 20 dices, 1 item and 5 RM cash',
              textAlign: TextAlign.center);
        }
      case 'chest':
        {
          return const Text('Community chest contains random credits rewards',
              textAlign: TextAlign.center);
        }
      case 'chance':
        {
          return const Text('Get random chances of getting or losing',
              textAlign: TextAlign.center);
        }
      case 'black_hole':
        {
          return const Text('A black hole can make you go any step back',
              textAlign: TextAlign.center);
        }
      case 'challenge':
        {
          return const Text(
              'Step on this slot, answer question the questions to fill the bar and earn credits',
              textAlign: TextAlign.center);
        }
      case 'treasure_hunt':
        {
          return const Text(
              'Guess the direction of the treasure. Guess correct and get the treasure. Wrong guess will make you lose credits',
              textAlign: TextAlign.center);
        }
      case 'worm_hole':
        {
          return const Text(
              'A wormhole will take you any step further on the board',
              textAlign: TextAlign.center);
        }
      case 'reward':
        {
          return const Text(
              'Step on it to get a star, when you will have 5 stars, you will earn 50 RM cash',
              textAlign: TextAlign.center);
        }
      default:
        return const SizedBox();
    }
  }

  Widget getPropertyStatusInfo(Slot slot, User user) {
    if (slot.owner != null && slot.owner!.serverId == user.serverId) {
      return Column(
        children: [
          const Text(
            'Owned by you',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // slot.owner!.profileImageUrl != null
          //     ? SizedBox(
          //         height: 50,
          //         width: 50,
          //         child: CachedNetworkImage(
          //             imageUrl: slot.owner!.profileImageUrl!))
          //     : const Icon(
          //         CupertinoIcons.person_alt_circle,
          //         color: Colors.black,
          //       ),
          Table(
            children:[ TableRow(
              children: [
                const Text('Rent:'),
                Row(
                  children: [
                    Text('${slot.getRent()}'),
                    const SizedBox(width: 5,),
                    Image.asset('assets/images/payment.png', height: 25, width: 25,),
                  ],
                ),
              ],
            ),
            ]
          ),
        ],
      );
    } else if (slot.owner != null && slot.owner!.serverId != user.serverId) {
      return Column(
        children: [
          // Text(
          //   'Owned by ${slot.owner!.id}',
          //   style: const TextStyle(fontWeight: FontWeight.bold),
          // ),
          // slot.owner!.profileImageUrl != null
          //     ? SizedBox(
          //         height: 50,
          //         width: 50,
          //         child: CachedNetworkImage(
          //             imageUrl: slot.owner!.profileImageUrl!))
          //     : const Icon(
          //         CupertinoIcons.person_alt_circle,
          //         color: Colors.black,
          //       ),
          Table(
              children:[ TableRow(
                children: [
                  Text('Rent:'),
                  Row(
                    children: [
                      Text('${slot.getRent()}'),
                      const SizedBox(width: 5,),
                      Image.asset('assets/images/payment.png', height: 25, width: 25,),
                    ],
                  ),
                ],
              ),
              ]
          ),
        ],
      );
    } else {
      return
        Center(
          child: Table(

            children:  [
              TableRow(

                children: [
                  const Text('Buy for:'),
                  Text('${50 + 1 + slot.index}'),
                ]
              )
            ],
          ),
        );
    }
  }
}
