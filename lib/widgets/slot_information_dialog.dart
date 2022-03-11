import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/models/user.dart';
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
                        child: Icon(Icons.cancel_outlined)),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text(
                    'Slot Information',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('Name: ${slot.name}'),
                  const SizedBox(
                    height: 2,
                  ),
                  slotInfo(slot, userProvider.user),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(25))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'OK',
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
            children: [
              getPropertyStatusInfo(slot, user),
              slot.status == 'for_sell'
                  ? Column(
                      children: [
                        const Text('For Urgent Sell'),
                        Text('Selling Price: ${slot.getHalfSellingPrice()}'),
                      ],
                    )
                  : Text('Upgraded Price: ${slot.updatedPrice}'),
              Text('Selling Price: ${slot.getSellingPrice()}')
            ],
          );
        }
      case 'start':
        {
          return const Text('This is the starting point of the game');
        }
      case 'end':
        {
          return const Text(
              'This is the end point of the slot. On your next dice roll you will be going from the Start again');
        }
      case 'chest':
        {
          return const Text('Community chest contains random credits rewards');
        }
      case 'chance':
        {
          return const Text('Text to be added');
        }
      case 'black_hole':
        {
          return const Text('A black hole can make you go any step back');
        }
      case 'challenge':
        {
          return const Text('Text to be added');
        }
      case 'treasure_hunt':
        {
          return const Text('Text to be added');
        }
      case 'worm_hole':
        {
          return const Text(
              'A wormhole will take you any step further on the board');
        }
      case 'reward':
        {
          return const Text(
              'Step on it to get a star, when you will have 5 stars, you will earn 50 credits');
        }
      default:
        return const SizedBox();
    }
  }

  Widget getPropertyStatusInfo(Slot slot, User user) {
    if (slot.owner != null && slot.owner!.serverId == user.serverId) {
      return Column(children: [
        const Text(
          'Owned by you', style: TextStyle(fontWeight: FontWeight.bold),),
        Text('Rent: ${slot.getRent()}'),
        Text('')
        ],);
    }
    else if (slot.owner != null && slot.owner!.serverId != user.serverId) {
      return Column(children: [
        Text('Owned by ${slot.owner!.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),),
        Text('Rent: ${slot.getRent()}'),

      ],);
    }
    else {
      return const Text('For Sell');
    }
  }

}

