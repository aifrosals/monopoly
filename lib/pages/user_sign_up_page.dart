import 'package:flutter/material.dart';
import 'package:monopoly/config/validator.dart';
import 'package:monopoly/pages/board_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class UserSignUpPage extends StatefulWidget {
  const UserSignUpPage({Key? key}) : super(key: key);

  @override
  State<UserSignUpPage> createState() => _UserSignUpPageState();
}

class _UserSignUpPageState extends State<UserSignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Center(
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
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
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null) {
                        return 'Cannot be empty';
                      } else if (!Validator.validateEmail(value)) {
                        return 'Enter correct e-mail';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration.collapsed(hintText: 'E-mail'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: TextFormField(
                    controller: _userNameController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration.collapsed(hintText: 'Username'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value == null) {
                        return 'Cannot be empty';
                      } else if (!Validator.validatePassword(value)) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    decoration:
                    const InputDecoration.collapsed(hintText: 'Password'),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Password does not match';
                      }
                      return null;
                    },
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Confirm Password'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        HelpingDialog.showLoadingDialog();
                        Map res = await userProvider.registerUserWithEmail(
                            _emailController.text,
                            _userNameController.text,
                            _passwordController.text,
                            _confirmPasswordController.text);
                        if (res['status'] == true) {
                          await boardProvider.getBoardSlots(userProvider.user);
                          diceProvider.resetFace();
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BoardPage()));
                        } else {
                          Navigator.pop(context);
                          HelpingDialog.showServerResponseDialog(
                              res['message']);
                        }
                      }
                    },
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
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () async {},
                    child: const Text(
                      'Continue as a Guest',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
