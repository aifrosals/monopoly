import 'package:flutter/material.dart';
import 'package:monopoly/config/values.dart';

class HelpingDialog {
  static showNotEnoughCredDialog() {
    showDialog(
        context: Values.navigatorKey.currentContext!,
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sorry! you do not have enough credits to buy',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  static showNotEnoughCredUpgradeDialog() {
    showDialog(
        context: Values.navigatorKey.currentContext!,
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
                        child: const Icon(Icons.cancel_outlined),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Sorry! you do not have enough credits to upgrade',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  static showServerResponseDialog(String body) {
    showDialog(
        context: Values.navigatorKey.currentContext!,
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

  static showLoadingDialog() {
    showDialog(
        barrierDismissible: false,
        context: Values.navigatorKey.currentContext!,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ));
  }
}
