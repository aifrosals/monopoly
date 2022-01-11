import 'package:flutter/material.dart';
import 'package:monopoly/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [Text('Status'), Text('Data')],
    ));
  }

  Widget getStatus() {
    switch (transaction.type) {
      case 'land':
        {
          return Column(
            children: [
              const Text('Land bought'),
              Text('Land bought on index ${transaction.slot.index}'),
              Text('Credits: ${transaction.amount}'),
            ],
          );
        }
      case 'seller':
        {
          return Column(
            children: [
              Text('${transaction.slot.name} bought'),
              Text(
                  '${transaction.slot.name} bought from ${transaction.sellerName} on index ${transaction.slot.index}'),
              Text('Credits: ${transaction.amount}'),
            ],
          );
        }
      case 'half':
        {
          return Column(
            children: [
              Text('${transaction.slot.name} bought'),
              Text(
                  '${transaction.slot.name} bought from ${transaction.sellerName} on index ${transaction.slot.index}'),
              Text('Credits: ${transaction.amount}'),
            ],
          );
        }
      case 'upgrade':
        {
          return Column(
            children: [
              Text('Property Upgraded'),
              Text(
                  'Property upgraded to ${transaction.slot.type} on index ${transaction.slot.index}'),
              Text('Credits: ${transaction.amount}'),
            ],
          );
        }
      default:
        return const SizedBox();
    }
  }
}
