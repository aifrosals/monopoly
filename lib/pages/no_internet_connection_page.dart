import 'package:flutter/material.dart';
import 'package:monopoly/pages/start_page.dart';

class NoInternetConnectionPage extends StatelessWidget {
  const NoInternetConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('No internet connection'),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StartPage()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Try Again',
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
    );
  }
}
