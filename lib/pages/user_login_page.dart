import 'package:flutter/material.dart';
import 'package:monopoly/pages/user_sing_up_page.dart';

class UserLoginPage extends StatelessWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Conquer the world of Monopoly',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                    fontSize: 25),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 70),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  decoration:
                      const InputDecoration.collapsed(hintText: 'E-mail'),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey[300]!)),
                child: TextField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {},
                  decoration:
                      const InputDecoration.collapsed(hintText: 'Password'),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {},
                  child: const Text(
                    'Let\'s Play!',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserSingUpPage()));
                  },
                  child: const Text(
                    'Do not have account? Signup here',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                  )),
            ],
          ),
        )),
      ),
    );
  }
}
