import 'package:flutter/material.dart';
import 'package:monopoly/pages/contact_us_page.dart';
import 'package:monopoly/pages/guest_register_page.dart';
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/pages/transaction_page.dart';
import 'package:monopoly/pages/user_login_page.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MonopolyDrawer extends StatelessWidget {
  const MonopolyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 5,
            ),
            ListTile(
              title: const Text('Transactions'),
              trailing: const Icon(Icons.assignment),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactionPage()));
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LearnMorePage()));
              },
              trailing: const Icon(Icons.info_outlined),
            ),
            Consumer<UserProvider>(builder: (context, userProvider, child) {
              return ListTile(
                title: const Text('Withdrawal'),
                onTap: () {
                  if (userProvider.user.guest) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GuestRegisterPage()));
                  }
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${userProvider.user.cash}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 2),
                    Image.asset(
                      'assets/images/dollar.png',
                      height: 30,
                      width: 30,
                    ),
                  ],
                ),
              );
            }),
            ListTile(
              title: const Text('Contact Us'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContactUsPage()));
              },
              trailing: const Icon(Icons.contact_support_rounded),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                userProvider.deleteSession();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UserLoginPage()),
                    (route) => false);
              },
              trailing: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }
}


