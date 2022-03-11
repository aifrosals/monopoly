import 'package:flutter/material.dart';
import 'package:monopoly/config/values.dart';

class HelpingDialog {
  static showNotEnoughCredDialog(int credits) {
    showDialog(
        context: Values.navigatorKey.currentContext!,
        builder: (context) =>
            Dialog(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Align(
                    //     alignment: Alignment.topRight,
                    //     child: InkWell(
                    //         onTap: () {
                    //           Navigator.pop(context);
                    //         },
                    //         child: const Icon(Icons.cancel_outlined))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sorry! you do not have $credits credits to buy',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ));
  }

  static showNotEnoughCredUpgradeDialog(int credits) {
    showDialog(
        context: Values.navigatorKey.currentContext!,
        builder: (context) =>
            Dialog(
              child: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: InkWell(
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //     },
                    //     child: const Icon(Icons.cancel_outlined),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Sorry! you do not $credits credits to upgrade',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Align(
                    //     alignment: Alignment.topRight,
                    //     child: InkWell(
                    //         onTap: () {
                    //           Navigator.pop(context);
                    //         },
                    //         child: const Icon(Icons.cancel_outlined))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        body,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(25))),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ],
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
