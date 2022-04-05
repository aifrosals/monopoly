import 'package:flutter/material.dart';
import 'package:monopoly/config/date_utility.dart';
import 'package:monopoly/models/transaction.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final int index;

  const TransactionTile(
      {Key? key, required this.transaction, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(2.5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(color: Colors.grey[300]!)),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${index + 1}.'),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getStatus(userProvider.user),
                    Text(DateUtility.formatDateFromString(transaction.date))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getStatus(User user) {
    switch (transaction.type) {
      case 'land':
        {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Land bought',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Land bought on slot number ${transaction.slot.index}'),
              Text('Credits: ${transaction.amount}'),
            ],
          );
        }
      case 'seller':
        {
          if (transaction.seller == user.serverId) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${transaction.slot.name} Sold',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '${transaction.slot.name} sold to ${transaction.buyerName} on slot number ${transaction.slot.index}'),
                Text('Credits: ${transaction.amount}'),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${transaction.slot.name} bought',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '${transaction.slot.name} bought from ${transaction.sellerName} on slot number ${transaction.slot.index}'),
                Text('Credits: ${transaction.amount}'),
              ],
            );
          }
        }
      case 'half':
        {
          if (transaction.seller == user.serverId) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${transaction.slot.name} bought',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '${transaction.slot.name} bought from ${transaction.sellerName} on slot number ${transaction.slot.index}'),
                Text('Credits: ${transaction.amount}'),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${transaction.slot.name} bought',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    '${transaction.slot.name} bought from ${transaction.sellerName} on slot number ${transaction.slot.index}'),
                Text('Credits: ${transaction.amount}'),
              ],
            );
          }
        }
      case 'upgrade':
        {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Property Upgraded',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  'Property upgraded to ${transaction.slot.type} on slot number ${transaction.slot.index}'),
              Text('Credits: ${transaction.amount}'),
            ],
          );
        }
      case 'rent':
        {
          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    transaction.sellerName != user.id
                        ? 'Rent Paid'
                        : 'Rent Received',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(transaction.sellerName != user.id
                    ? '${transaction.amount} credits rent paid to ${transaction.sellerName} for ${transaction.slot.type} on slot number ${transaction.slot.index}'
                    : '${transaction.amount} credits rent received from ${transaction.buyerName} from ${transaction.slot.type} on slot number ${transaction.slot.index}'),
                Text('Credits: ${transaction.amount}')
              ]);
        }
      case 'chest':
        {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Received Community Chest',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Received ${transaction.amount} credits from community chest on number ${transaction.slot.index}'),
            ],
          );
        }
      case 'reward':
        {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Received Reward',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                  'Received ${transaction.amount} RM credits on number ${transaction.slot.index}'),
            ],
          );
        }
      default:
        return const SizedBox();
    }
  }
}
