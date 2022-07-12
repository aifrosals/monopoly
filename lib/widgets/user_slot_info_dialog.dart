import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/socket_provider.dart';
import 'package:provider/provider.dart';

class UserSlotInfoDialog extends StatelessWidget {
  const UserSlotInfoDialog({Key? key, required this.owner}) : super(key: key);
  final User owner;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              top: 60 + 16,
              bottom: 16,
              left: 16,
              right: 16,
            ),
            margin: const EdgeInsets.only(top: 60),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  owner.id,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16.0),
                Table(
                  children: [
                    TableRow(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Cards     '),
                          Image.asset(
                            'assets/images/cards.png',
                            height: 25,
                          ),
                        ],
                      ),
                      Text(
                        owner.getItemCount().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Credits  '),
                          Image.asset(
                            'assets/images/gold_coin.png',
                            height: 25,
                          ),
                        ],
                      ),
                      Text(
                        owner.credits.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ]),
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: CircleAvatar(
                backgroundImage: owner.profileImageUrl != null
                    ? CachedNetworkImageProvider(owner.profileImageUrl!)
                    : null,
                backgroundColor: Colors.blueAccent,
                radius: 50,
                child: owner.profileImageUrl == null
                    ? const Icon(CupertinoIcons.person_alt_circle)
                    : const SizedBox(),
              ),
            ),
          ),
          Positioned(
            top: 104,
            left: 80,
            right: 16,
            child: Consumer<SocketProvider>(
                builder: (context, socketProvider, child) {
              return CircleAvatar(
                backgroundColor: socketProvider.checkUserOnline(owner.serverId)
                    ? Colors.green
                    : Colors.grey,
                radius: 9,
              );
            }),
          ),
        ],
      ),
    );
  }
}
