import 'package:flutter/material.dart';
import 'package:monopoly/pages/user_login_page.dart';

class Page3 extends StatelessWidget {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          minRadius: 150,
          backgroundImage: AssetImage('assets/images/money.png'),
        ),
        const SizedBox(height: 10),
        const Text('Earn and withdraw money'),
        const SizedBox(height: 10),
        TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserLoginPage()));
            },
            child: const Text(
              'Let\'s Play!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
      ],
    );
  }
}
