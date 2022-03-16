import 'package:flutter/material.dart';

class UserChangePremiumDialog extends StatelessWidget {
  final bool premium;

  const UserChangePremiumDialog({Key? key, required this.premium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Dialog(
        child: SizedBox(
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  premium
                      ? 'Are you sure? You want to set this user as premium.'
                      : 'Are you sure? you want to remove this user from premium.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('yes'),
                    ),
                    const SizedBox(width: 100),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
