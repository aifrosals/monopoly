import 'package:flutter/material.dart';
import 'package:monopoly/config/validator.dart';
import 'package:monopoly/pages/user_login_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class GuestRegisterOrLogoutPage extends StatefulWidget {
  const GuestRegisterOrLogoutPage({Key? key}) : super(key: key);

  @override
  State<GuestRegisterOrLogoutPage> createState() =>
      _GuestRegisterOrLogoutPageState();
}

class _GuestRegisterOrLogoutPageState extends State<GuestRegisterOrLogoutPage> {
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
                    'Sign Up with e-mail before you logout otherwise your data will be lost',
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
                          Map res = await userProvider.registerGuestWithEmail(
                              _emailController.text,
                              _userNameController.text,
                              _passwordController.text,
                              _confirmPasswordController.text);
                          if (res['status'] == true) {
                            await boardProvider
                                .getBoardSlots(userProvider.user);
                            diceProvider.resetFace();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } else {
                            Navigator.pop(context);
                            HelpingDialog.showServerResponseDialog(
                                res['message']);
                          }
                        }
                      },
                      child: const Text(
                        'Sing Up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                      onTap: () async {
                        userProvider.deleteSession();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserLoginPage()),
                            (route) => false);
                      },
                      child: const Text(
                        'Still want to Logout',
                        style: TextStyle(color: Colors.red),
                      ))
                ],
              ),
            ),
          ),
        ),
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
