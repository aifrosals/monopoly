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
              const Text('Buy Property', style: TextStyle(fontWeight: FontWeight.bold),),

              const Text(
                  'The initial property that you can buy is a land for 50 + steps credits. The steps is the number where the property is'),
              const SizedBox(
                height: 5,
              ),
              const Text('Upgrade Property', style: TextStyle(fontWeight: FontWeight.bold),),
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
                    Text('Price to Upgrade (credtis)')
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('1'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('initial price + steps x 2'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('2'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('initial price + steps x 2'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('3'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('initial price + steps x 4'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('4'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('initial price + steps x 16'),
                    )
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('5'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('initial price + steps x 32'),
                    )
                  ]),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Text('Sell Urgent', style: TextStyle(fontWeight: FontWeight.bold),),
              const Text(
                  '''You can also sell your property urgently which will let you set your property for sale at half selling price. Any Player that will step on your property can buy this immediately. Otherwise they have to step 3 times to buy the property'''),
              const SizedBox(
                height: 5,
              ),
              const Text('Timer', style: TextStyle(fontWeight: FontWeight.bold),),
              const Text(
                  '''You will have 90 seconds to take an action. If any other player takes action before then they can be the owner of the property.''')
            ],
          ),
        ),
      ),
    );
  }
}
