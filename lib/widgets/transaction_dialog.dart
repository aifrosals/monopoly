import 'package:flutter/material.dart';
import 'package:monopoly/providers/transaction_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';

class TransactionDialog extends StatelessWidget {
  const TransactionDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return ChangeNotifierProvider(
        create: (context) => TransactionProvider(userProvider.user),
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 400,
              child: Column(
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                  const SizedBox(height: 2,),
                  Flexible(
                    child: Consumer<TransactionProvider>(
                        builder: (context, transactionProvider, child) {
                          if (transactionProvider.loadTransaction) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (transactionProvider.errorMessage != '') {
                            return Center(
                                child: Text(
                                  transactionProvider.errorMessage,
                                  textAlign: TextAlign.center,
                                ));
                          } else
                          if (transactionProvider.transactions.isNotEmpty) {
                            return ListView.builder(
                                itemCount: transactionProvider.transactions
                                    .length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TransactionTile(
                                    index: index,
                                    transaction:
                                    transactionProvider.transactions[index],
                                  );
                                });
                          } else {
                            return const Center(
                                child: Text('No transactions to show'));
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
