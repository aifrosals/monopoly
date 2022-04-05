import 'package:flutter/material.dart';
import 'package:monopoly/models/user.dart';
import 'package:monopoly/providers/timer_provider.dart';
import 'package:monopoly/providers/user_questions_provider.dart';
import 'package:provider/provider.dart';

class UserChallengeDialog extends StatelessWidget {
  final User user;

  const UserChallengeDialog({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ChangeNotifierProvider<UserQuestionsProvider>(
        create: (context) => UserQuestionsProvider(),
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
                        child: Image.asset(
                          'assets/images/challenge.jpg',
                          height: 190,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel_outlined)),
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Challenge',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Consumer<UserQuestionsProvider>(
                  builder: (context, userQuestionProvider, child) {
                if (userQuestionProvider.showR) {
                  if (userQuestionProvider.questionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        userQuestionProvider.resultMessage,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                } else if (userQuestionProvider.showQ) {
                  if (userQuestionProvider.questionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (userQuestionProvider.question != null &&
                      userQuestionProvider.error == '') {
                    return ChangeNotifierProvider(
                      create: (context) => TimerProvider(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 18.0, right: 18.0),
                            child: Text(
                              userQuestionProvider.question!.statement,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400]!),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Consumer<TimerProvider>(
                              builder: (context, timerProvider, child) {
                            if (timerProvider.time == 0) {
                              Navigator.pop(context);
                            }
                            return Text(
                              'Count down: ${timerProvider.time}s',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            );
                          }),
                          const SizedBox(
                            height: 10,
                          ),
                          userQuestionProvider.question!.options != null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: userQuestionProvider
                                      .question!.options!
                                      .asMap()
                                      .map((i, e) => MapEntry(
                                          i,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 18.0,
                                                right: 18.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: TextButton(
                                                      style: TextButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.amber,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          25))),
                                                      onPressed: () {
                                                        userQuestionProvider
                                                            .question!
                                                            .answer = i;
                                                        userQuestionProvider
                                                            .showResults();
                                                        userQuestionProvider
                                                            .submitQuestion(
                                                                user);
                                                      },
                                                      child: Text(
                                                        e,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ),
                                              ],
                                            ),
                                          )))
                                      .values
                                      .toList())
                              : const SizedBox(),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        userQuestionProvider.error,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: Text(
                          'Fully charge your bar will get 500 credits. Correct answer get 3 points. Wrong answer deduct 1 point.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[400]!),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0, right: 28.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Container(
                                  height: 20,
                                  color: Colors.white,
                                  child: LinearProgressIndicator(
                                    value: user.challengeProgress / 10,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '${user.challengeProgress}/10',
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey[400]!),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Answer only one question',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25))),
                                  onPressed: () {
                                    userQuestionProvider.showQuestion(user);
                                  },
                                  child: const Text(
                                    'Start Now',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
