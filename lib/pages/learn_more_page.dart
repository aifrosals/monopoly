import 'package:flutter/material.dart';

class LearnMorePage extends StatelessWidget {
  const LearnMorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn More'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                  'The initial property that you can buy is a land for 50 credits'),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  'Upgrade the property you own and earn more rent from other users who stay at your property'),
              const SizedBox(
                height: 5,
              ),
              const Text('Here is how you upgrade the property'),
              Table(
                border: TableBorder.all(color: Colors.grey[300]!),
                children: const [
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Level'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Name'),
                      ),
                    ),
                    Text('Price to Upgrade (credtis)')
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('1'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('House'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('100'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('2'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Shop'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('200'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('3'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Condo'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('400'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('4'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Theme Park or Business Center'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('800'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('5'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('City'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('1600'),
                    )
                  ]),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  '''You can also sell your property urgently which will let you set your property for sale. Any Player that will step on your property can buy this immediately. Otherwise they have to step 3 times to buy the property'''),
              const SizedBox(
                height: 5,
              ),
              const Text(
                  'You will have 90 seconds to take an action. If any other player takes action before then they can be the owner of the property.')
            ],
          ),
        ),
      ),
    );
  }
}
