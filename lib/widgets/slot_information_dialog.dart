import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SlotInformationDialog extends StatelessWidget {
  final Slot slot;

  const SlotInformationDialog({Key? key, required this.slot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            slotInfo(slot, userProvider.user)
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
              ) :
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

