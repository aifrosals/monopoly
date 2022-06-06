import 'package:flutter/material.dart';
import 'package:monopoly/models/slot.dart';

class Transaction {
  String buyer;
  String buyerName;
  String? seller;
  String? sellerName;
  String actor;
  int amount;
  String type;
  Slot slot;
  String date;

  Transaction(
      {required this.date,
      required this.buyerName,
      this.sellerName,
      required this.type,
      required this.slot,
      required this.amount,
      required this.buyer,
      required this.actor,
      this.seller});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    Slot _slot = Slot(
      index: 3000,
      name: '',
      color: Colors.black,
      initialType: '',
      type: '',
      slotKey: GlobalKey());
    try {
      _slot = Slot.fromJson(json['child']);
    } catch (error, st) {
      debugPrint('Transaction model $error $st');
    }
    return Transaction(
        type: json['type'],
        slot: _slot,
        amount: json['amount'],
        buyer: json['buyer'],
        seller: json['seller'] ?? '',
        buyerName: json['buyer_name'],
        sellerName: json['seller_name'],
        actor: json['actor'],
        date: json['createdAt']);
  }
}
