import 'package:flutter/material.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

import '../config/validator.dart';
import '../providers/user_provider.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              const Text('Find your account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              const SizedBox(height: 10,),
              const Text('Enter your email to reset password', style: TextStyle(fontSize: 16),),
              const SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10),
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
              const SizedBox(height: 20,),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.amber,
                  ),
                  onPressed: () async {


                    if (_formKey.currentState!.validate()) {
                       userProvider.forgetPassword(_emailController.text);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Request Reset Password',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
