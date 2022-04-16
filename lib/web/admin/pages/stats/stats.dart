import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/web/admin/pages/stats/login_hitory_chart.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Flex(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            direction: (ScreenConfig.screenWidth > 800)
                ? Axis.horizontal
                : Axis.vertical,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100,
                width: 230,
                child: Card(
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.red, Colors.redAccent])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Daily Active Users',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Icon(Icons.group_outlined,
                                      color: Colors.white)
                                ],
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 230,
                child: Card(
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.deepOrange, Colors.orange])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Registered Users',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Icon(
                                      CupertinoIcons
                                          .person_crop_circle_fill_badge_plus,
                                      color: Colors.white)
                                ],
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 230,
                child: Card(
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.green, Colors.lightGreen])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Guests',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Icon(
                                      CupertinoIcons.person_2_square_stack_fill,
                                      color: Colors.white)
                                ],
                              ),
                              Text(
                                '1',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                width: 230,
                child: Card(
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [Colors.indigo, Colors.blue])),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Daily Active Users',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Icon(Icons.groups_rounded,
                                      color: Colors.white)
                                ],
                              ),
                              Text(
                                '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TimeSeriesBar.withSampleData(),
          )),
          const SizedBox(
            height: 20,
          ),
          Flex(
            direction: (ScreenConfig.screenWidth > 800)
                ? Axis.horizontal
                : Axis.vertical,
            children: [
              ScreenConfig.screenWidth > 800
                  ? Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 230,
                        child: Card(
                          elevation: 6.5,
                          child: InkWell(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white12),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '3 days inactive users',
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 4,
                                              value: 1,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.grey[400]!),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 4,
                                              value: 0.7,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                              child: Center(child: Text('98%')))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      width: 230,
                      child: Card(
                        elevation: 6.5,
                        child: InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '3 days inactive users',
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 4,
                                          value: 1,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey[400]!),
                                        ),
                                        CircularProgressIndicator(
                                          strokeWidth: 4,
                                          value: 0.7,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.deepPurple,
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: Center(child: Text('98%')))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                width: 20,
              ),
              ScreenConfig.screenWidth > 800
                  ? Expanded(
                      child: SizedBox(
                        height: 100,
                        width: 230,
                        child: Card(
                          elevation: 6.5,
                          child: InkWell(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white12),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FittedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Weekly inactive users',
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              '0',
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        children: [
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 4,
                                              value: 1,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.grey[400]!),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 4,
                                              value: 0.7,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                Colors.deepPurple,
                                              ),
                                            ),
                                          ),
                                          Positioned.fill(
                                              child: Center(child: Text('98%')))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      width: 230,
                      child: Card(
                        elevation: 6.5,
                        child: InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Weekly inactive users',
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            '0',
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Stack(
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 4,
                                          value: 1,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.grey[400]!),
                                        ),
                                        CircularProgressIndicator(
                                          strokeWidth: 4,
                                          value: 0.7,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.deepPurple,
                                          ),
                                        ),
                                        Positioned.fill(
                                            child: Center(child: Text('98%')))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ],
          )
        ],
      ),
    );
  }
}
