import 'package:flutter/material.dart';
import 'package:monopoly/providers/transaction_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  //TODO: Provide the realtime transactions update

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Transactions',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Your Actions',
                icon: Icon(Icons.text_snippet_rounded),
              ),
              Tab(text: 'Other', icon: Icon(Icons.text_snippet_outlined))
            ],
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) => TransactionProvider(userProvider.user),
          child: TabBarView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 2,
                    ),
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
                        } else if (transactionProvider
                            .activeTransaction.isNotEmpty) {
                          return ListView.builder(
                              itemCount:
                                  transactionProvider.activeTransaction.length,
                              itemBuilder: (BuildContext context, int index) {
                                return TransactionTile(
                                  index: index,
                                  transaction: transactionProvider
                                      .activeTransaction[index],
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 2,
                    ),
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
                        } else if (transactionProvider
                            .passiveTransaction.isNotEmpty) {
                          return ListView.builder(
                              itemCount:
                                  transactionProvider.passiveTransaction.length,
                              itemBuilder: (BuildContext context, int index) {
                                return TransactionTile(
                                  index: index,
                                  transaction: transactionProvider
                                      .passiveTransaction[index],
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
            ],
          ),
        ),
      ),
    );
  }
}
