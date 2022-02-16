import 'package:flutter/material.dart';
import 'package:monopoly/config/values.dart';

class WebDialog {
  static showServerResponseDialog(String body) {
    showDialog(
        context: Values.adminNavigatorKey.currentContext!,
        builder: (context) => Dialog(
              child: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.cancel_outlined))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        body,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
