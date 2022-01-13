import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';
import 'package:monopoly/models/user.dart';

class SlotInformationDialog extends StatelessWidget {
  final Slot slot;

  const SlotInformationDialog({Key? key, required this.slot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Slot Information', style: TextStyle(fontWeight: FontWeight.bold),),
          Text('Name: ${slot.name}')
        ],
      ),
    );
  }


  Widget slotInfo(Slot slot, User user) {
    switch (slot.type) {
      case 'land':
        {
          return Column(
            children: [
              getPropertyStatusInfo(slot, user),
              slot.status == 'for_sell' ?
              Column(
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
      case ''
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

