import 'package:flutter/material.dart';
import 'package:monopoly/config/validator.dart';
import 'package:monopoly/pages/board_page.dart';
import 'package:monopoly/pages/forgot_password_page.dart';
import 'package:monopoly/pages/user_sign_up_page.dart';
import 'package:monopoly/providers/board_provider.dart';
import 'package:monopoly/providers/dice_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final boardProvider = Provider.of<BoardProvider>(context, listen: false);
    final diceProvider = Provider.of<DiceProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
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
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onChanged: (value) {},
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
                const SizedBox(height: 10,),
                InkWell(
                  onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordPage()));
                  },
                  child: const Align(
                      alignment: Alignment.topRight,
                      child: Text('Forgot Password?')),
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
                        Map res = await userProvider.loginWithEmail(
                          _emailController.text,
                          _passwordController.text,
                        );
                        if (res['status'] == true) {
                          Map res = await boardProvider
                              .getBoardSlots(userProvider.user);
                          if (res['status'] == true) {
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
                        } else {
                          Navigator.pop(context);
                          HelpingDialog.showServerResponseDialog(
                              res['message']);
                        }
                      }
                    },
                    child: const Text(
                      'Login',
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
                              builder: (context) => const UserSignUpPage()));
                    },
                    child: const Text(
                      'Do not have account? Signup here',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(height: 5),
                TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.pink,
                        backgroundColor: Colors.grey[200]),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              const Center(child: CircularProgressIndicator()));
                      await userProvider.login('user3');
                      await boardProvider.getBoardSlots(userProvider.user);
                      diceProvider.resetFace();
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BoardPage()));
                    },
                    child: const Text('Login user 3')),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
