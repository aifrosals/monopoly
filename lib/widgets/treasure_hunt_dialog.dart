import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/treasure_hunt_provider.dart';
import 'package:provider/provider.dart';
import 'package:monopoly/config/extensions.dart';
import 'package:monopoly/enums/direction.dart';
import 'package:monopoly/enums/treasure_state.dart';

class TreasureHuntDialog extends StatelessWidget {
  final User user;

  const TreasureHuntDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ChangeNotifierProvider<TreasureHuntProvider>(
        create: (context) => TreasureHuntProvider(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ColorFiltered(
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.5), BlendMode.darken),
                          child: Image.asset(
                            'assets/images/treasure_hunt.png',
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      // Align(
                      //   alignment: Alignment.topRight,
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: InkWell(
                      //         onTap: () {
                      //           Navigator.pop(context);
                      //         },
                      //         child: const Icon(
                      //           Icons.cancel_outlined,
                      //           color: Colors.white,
                      //         )),
                      //   ),
                      // ),
                      Consumer<TreasureHuntProvider>(
                          builder: (context, treasureHuntProvider, child) {
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Stack(
                                          children: [
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              30 / 360),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/compass.png'))),
                                          ),
                                        ),
                                        const Positioned(
                                            left: 20,
                                            top: 10,
                                            child: Text(
                                              '1st',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        treasureHuntProvider
                                                .answeredDirections.isNotEmpty
                                            ? Positioned.fill(
                                                right: 10,
                                                top: 11,
                                                child: Center(
                                                    child: Text(
                                                  treasureHuntProvider
                                                      .directions[0]
                                                      .toShortString()
                                                      .capitalize(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: FittedBox(
                                            child: Text(
                                          '30 credits\n1 item',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              30 / 360),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/compass.png'))),
                                          ),
                                        ),
                                        const Positioned(
                                            left: 20,
                                            top: 10,
                                            child: Text(
                                              '2nd',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        treasureHuntProvider.answeredDirections
                                                    .length >=
                                                2
                                            ? Positioned.fill(
                                                right: 10,
                                                top: 11,
                                                child: Center(
                                                    child: Text(
                                                  treasureHuntProvider
                                                      .directions[1]
                                                      .toShortString()
                                                      .capitalize(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: FittedBox(
                                            child: Text(
                                          '100 credits\n2 items',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              30 / 360),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/compass.png'))),
                                          ),
                                        ),
                                        const Positioned(
                                            left: 20,
                                            top: 10,
                                            child: Text(
                                              '3rd',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        treasureHuntProvider.answeredDirections
                                                    .length >=
                                                3
                                            ? Positioned.fill(
                                                right: 10,
                                                top: 11,
                                                child: Center(
                                                    child: Text(
                                                  treasureHuntProvider
                                                      .directions[2]
                                                      .toShortString()
                                                      .capitalize(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: FittedBox(
                                            child: Text(
                                          '500 credits\n3 items',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )))
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              30 / 360),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/compass.png'))),
                                          ),
                                        ),
                                        const Positioned(
                                            left: 20,
                                            top: 10,
                                            child: Text(
                                              '4th',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        treasureHuntProvider.answeredDirections
                                                    .length >=
                                                4
                                            ? Positioned.fill(
                                                right: 10,
                                                top: 11,
                                                child: Center(
                                                    child: Text(
                                                  treasureHuntProvider
                                                      .directions[3]
                                                      .toShortString()
                                                      .capitalize(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: FittedBox(
                                            child: Text(
                                          '1500 credits\n4 items',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              30 / 360),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/compass.png'))),
                                          ),
                                        ),
                                        const Positioned(
                                            left: 20,
                                            top: 10,
                                            child: Text(
                                              '5th',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        treasureHuntProvider.answeredDirections
                                                    .length >=
                                                5
                                            ? Positioned.fill(
                                                right: 10,
                                                top: 11,
                                                child: Center(
                                                    child: Text(
                                                  treasureHuntProvider
                                                      .directions[4]
                                                      .toShortString()
                                                      .capitalize(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: FittedBox(
                                            child: Text(
                                          '5000 credits\n5 items',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )))
                                  ],
                                ),
                                Column(
                                  children: [
                                    Stack(
                                      children: [
                                        RotationTransition(
                                          turns: const AlwaysStoppedAnimation(
                                              30 / 360),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/compass.png'))),
                                          ),
                                        ),
                                        const Positioned(
                                            left: 20,
                                            top: 10,
                                            child: Text(
                                              '6th',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        treasureHuntProvider.answeredDirections
                                                    .length ==
                                                6
                                            ? Positioned.fill(
                                                right: 10,
                                                top: 11,
                                                child: Center(
                                                    child: Text(
                                                  treasureHuntProvider
                                                      .directions[5]
                                                      .toShortString()
                                                      .capitalize(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )))
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                        width: 70,
                                        height: 20,
                                        child: FittedBox(
                                            child: Text(
                                          '20000 credits\n6 items',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        )))
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ],
              ),
              Consumer<TreasureHuntProvider>(
                  builder: (context, treasureHuntProvider, child) {
                if (treasureHuntProvider.treasureHuntState ==
                    TreasureHuntStates.hunt) {
                  return Column(
                    children: [
                      treasureHuntProvider.turn == 6
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Guess your ${treasureHuntProvider.getDirectionText()} Direction',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                      const SizedBox(height: 5),
                      treasureHuntProvider.turn == 0
                          ? const SizedBox()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 18.0, right: 18.0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[400]!),
                                    children: [
                                      TextSpan(text: 'You will get '),
                                      TextSpan(
                                          text: treasureHuntProvider
                                              .getRewardText(),
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(text: ' if you take reward.')
                                    ]),
                              ),
                            ),
                      Column(
                        children: [
                          treasureHuntProvider.turn == 6
                              ? const SizedBox()
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25))),
                                          onPressed: () async {
                                            bool res = treasureHuntProvider
                                                .checkAnswer(Directions.east);
                                            if (!res) {
                                              treasureHuntProvider
                                                  .lostHunt(user);
                                            }
                                          },
                                          child: const SizedBox(
                                              height: 30,
                                              width: 80,
                                              child: Center(
                                                child: Text(
                                                  'East',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25))),
                                          onPressed: () async {
                                            bool res = treasureHuntProvider
                                                .checkAnswer(Directions.west);
                                            if (!res) {
                                              treasureHuntProvider
                                                  .lostHunt(user);
                                            }
                                          },
                                          child: const SizedBox(
                                              height: 30,
                                              width: 80,
                                              child: Center(
                                                child: Text(
                                                  'West',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25))),
                                          onPressed: () async {
                                            bool res = treasureHuntProvider
                                                .checkAnswer(Directions.north);
                                            if (!res) {
                                              treasureHuntProvider
                                                  .lostHunt(user);
                                            }
                                          },
                                          child: const SizedBox(
                                              height: 30,
                                              width: 80,
                                              child: Center(
                                                child: Text(
                                                  'North',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                              backgroundColor: Colors.amber,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25))),
                                          onPressed: () async {
                                            bool res = treasureHuntProvider
                                                .checkAnswer(Directions.south);
                                            if (!res) {
                                              treasureHuntProvider
                                                  .lostHunt(user);
                                            }
                                          },
                                          child: const SizedBox(
                                              height: 30,
                                              width: 80,
                                              child: Center(
                                                child: Text(
                                                  'South',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          const SizedBox(
                            height: 5,
                          ),
                        treasureHuntProvider.answeredDirections.length >= 2
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(100))),
                                  onPressed: () async {
                                    await treasureHuntProvider.getRewards(user);
                                  },
                                  child: const SizedBox(
                                    height: 35,
                                    width: 200,
                              child: Center(
                                child: Text(
                                  'Take Rewards',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))
                            : const SizedBox(),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  );
                } else if (treasureHuntProvider.treasureHuntState ==
                    TreasureHuntStates.postHunt) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Treasure Hunt',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                            'You will get reward with each correct guess. If you guessed wrong you will lose all of your credits.'),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                          onPressed: () {
                            treasureHuntProvider.setContinueHunt();
                          },
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  );
                } else if (treasureHuntProvider.treasureHuntState ==
                    TreasureHuntStates.loading) {
                  return Column(
                    children: const [
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                        child: CircularProgressIndicator(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                } else if (treasureHuntProvider.treasureHuntState ==
                    TreasureHuntStates.result) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          treasureHuntProvider.message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
