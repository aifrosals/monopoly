import 'package:flutter/material.dart';
import 'package:monopoly/config/validator.dart';

class UserAddDicesDialog extends StatefulWidget {
  const UserAddDicesDialog({Key? key}) : super(key: key);

  @override
  State<UserAddDicesDialog> createState() => _UserAddDicesDiaState();
}

class _UserAddDicesDiaState extends State<UserAddDicesDialog> {
  final TextEditingController _diceTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Add Dice',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Enter Dices:'),
                    const SizedBox(width: 7),
                    Container(
                      width: 170,
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!)),
                      child: TextFormField(
                        controller: _diceTextController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration.collapsed(hintText: '0'),
                        validator: (value) {
                          if (value == null) {
                            return 'Cannot be empty';
                          } else if (!Validator.validateDigit(value)) {
                            return 'Should be a digit';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          int dices = 0;
                          dices = int.tryParse(_diceTextController.text) ?? 0;
                          Navigator.pop(context, dices);
                        }
                      },
                      child: const Text('yes'),
                    ),
                    const SizedBox(width: 100),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
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

  @override
  void dispose() {
    _diceTextController.dispose();
    super.dispose();
  }
}
