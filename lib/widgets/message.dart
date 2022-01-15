import 'package:flutter/material.dart';
import 'package:monopoly/config/values.dart';

class Message {
  Message._();

  static showMessage(String message) {
    SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(message)),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.cancel_outlined),
            ),
            onTap: () {
              Values.snackBarKey.currentState?.hideCurrentSnackBar();
            },
          )
        ],
      ),
    );
    Values.snackBarKey.currentState?.showSnackBar(snackBar);
  }
}
