import 'package:flutter/material.dart';
import 'package:monopoly/pages/contact_us_page.dart';
import 'package:monopoly/pages/learn_more_page.dart';
import 'package:monopoly/pages/login_page.dart';
import 'package:monopoly/pages/transaction_page.dart';

class MonopolyDrawer extends StatelessWidget {
  const MonopolyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 5,),
            ListTile(title: Text('Transactions'),
              trailing: const Icon(Icons.assignment),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TransactionPage()));
              },),
            ListTile(title: Text('About Us'), onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LearnMorePage()));
            }, trailing: const Icon(Icons.info_outlined),),
            ListTile(title: Text('Withdrawal'),
              trailing: Image.asset(
                'assets/images/dollar.png', height: 30, width: 30,),),
            ListTile(title: Text('Contact Us'), onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const ContactUsPage()));
            }, trailing: Icon(Icons.contact_support_rounded),),
            ListTile(title: Text('Logout'), onTap: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()), (
                      route) => false);
            }, trailing: Icon(Icons.logout),),
          ],
        ),
      ),
    );
  }
}


