import 'package:flutter/material.dart';
import 'package:monopoly/providers/transaction_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/transaction_tile.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final _scrollController = ScrollController();
  late UserProvider userProvider;
  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    transactionProvider.getTransactions(userProvider.user);
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() async {
    debugPrint(_scrollController.position.extentAfter.toString());
    if (_scrollController.position.extentAfter < 1) {
      transactionProvider.getPaginatedTransactions(userProvider.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Transactions',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Your Actions',
                icon: Icon(Icons.text_snippet_rounded),
              ),
              Tab(text: 'Other', icon: Icon(Icons.text_snippet_outlined))
            ],
          ),
        ),
        body: TabBarView(
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
                        return const Center(child: CircularProgressIndicator());
                      } else if (transactionProvider.errorMessage != '') {
                        return Center(
                            child: Text(
                          transactionProvider.errorMessage,
                          textAlign: TextAlign.center,
                        ));
                      } else if (transactionProvider
                          .activeTransaction.isNotEmpty) {
                        return ListView.builder(
                            controller: _scrollController,
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
                  Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, child) {
                    if (transactionProvider.loadPaginatedTransactions) {
                      return const Center(child: Text('Loading...'));
                    } else {
                      return const SizedBox();
                    }
                  })
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
                        return const Center(child: CircularProgressIndicator());
                      } else if (transactionProvider.errorMessage != '') {
                        return Center(
                            child: Text(
                          transactionProvider.errorMessage,
                          textAlign: TextAlign.center,
                        ));
                      } else if (transactionProvider
                          .passiveTransaction.isNotEmpty) {
                        return ListView.builder(
                            controller: _scrollController,
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
                  Consumer<TransactionProvider>(
                      builder: (context, transactionProvider, child) {
                    if (transactionProvider.loadPaginatedTransactions) {
                      return const Center(child: Text('Loading...'));
                    } else {
                      return const SizedBox();
                    }
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
