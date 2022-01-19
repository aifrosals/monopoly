import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/models/user.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _activeTransactions = [];
  List<Transaction> _passiveTransaction = [];
  bool _loadTransactions = false;
  String _errorMessage = '';

  TransactionProvider(User user) {
    getTransactions(user);
  }

  getTransactions(User user) async {
    try {
      _loadTransactions = true;
      Uri url =
          Uri.parse('${ApiConstants.domain}${ApiConstants.getTransaction}');
      var body = {'userId': user.serverId};
      var response = await http.post(
        url, body: json.encode(body),
        //TODO: Create jwt on server
        headers: {
          'Content-Type': 'application/json'
          // HttpHeaders.authorizationHeader: 'Bearer ${user.token}'
          //'${user.token}',
        },
      );
      debugPrint(
          'TransactionProvider getTransactions response ${response.body}');
      if (response.statusCode == 200) {
        debugPrint(
            'TransactionProvider getTransaction response ${response.body}');
        var resData = json.decode(response.body) as List;
        _transactions = resData.map((e) => Transaction.fromJson(e)).toList();
        setTransactions(user);
        _errorMessage = '';
      } else {
        _errorMessage = response.body;
      }
    } catch (error, st) {
      debugPrint('TransactionProvider getTransaction $error $st');
      _errorMessage = "Unknown error";
    } finally {
      _loadTransactions = false;
      notifyListeners();
    }
  }

  setTransactions(User user) {
    _activeTransactions = [];
    _passiveTransaction = [];
    if (_transactions.isNotEmpty) {
      for (Transaction transaction in transactions) {
        if (transaction.actor == user.serverId) {
          _activeTransactions.add(transaction);
        } else {
          _passiveTransaction.add(transaction);
        }
      }
    }
  }

  bool get loadTransaction => _loadTransactions;

  List<Transaction> get transactions => _transactions;

  List<Transaction> get activeTransaction => _activeTransactions;

  List<Transaction> get passiveTransaction => _passiveTransaction;

  String get errorMessage => _errorMessage;
}
