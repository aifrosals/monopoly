import 'package:flutter/material.dart';
import 'package:monopoly/providers/contact_us_provider.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ContactUsProvider>(
      create: (context) => ContactUsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Contact Us'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10,),
                const Text('Why do you want to contact us?',
                  textAlign: TextAlign.center,),
                const SizedBox(height: 10,),
                Consumer<ContactUsProvider>(
                    builder: (context, contactUsProvider, child) {
                      return DropdownButton<String>(
                        isExpanded: true,
                        value: contactUsProvider.type,
                        items: contactUsProvider.types.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          contactUsProvider.setType(value ?? '');
                        },
                      );
                    }
                ),
                const SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)
                  ),
                  child: const TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Enter your e-mail'),
                  ),
                ),
                const SizedBox(height: 10,),

                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!)),
                  child: const TextField(
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(
                        hintText: 'Wirte here what you want to say'),
                  ),
                ),
                const SizedBox(height: 10,),
                TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(25))),
                    onPressed: () {},
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
