import 'package:flutter/material.dart';
import 'package:monopoly/models/question.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/admin_questions_provider.dart';
import 'package:monopoly/web/admin/pages/challenge/questions_list.dart';
import 'package:provider/provider.dart';

class QuestionMenu extends StatefulWidget {
  static const String route = '/question_menu';

  const QuestionMenu({Key? key}) : super(key: key);

  @override
  State<QuestionMenu> createState() => _QuestionMenuState();
}

class _QuestionMenuState extends State<QuestionMenu> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<AdminQuestionProvider>(context, listen: false).getQuestions(
          Provider.of<AdminProvider>(context, listen: false).admin!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<AdminQuestionProvider>(
                  builder: (context, adminQuestionProvider, child) {
                return adminQuestionProvider.questionLoading
                    ? const LinearProgressIndicator()
                    : const SizedBox();
              }),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () => _showQuestionBottomSheet(context),
                      child: const Text('Add Question')),
                ),
              ),
              const Divider(
                color: Colors.grey,
                height: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<AdminQuestionProvider>(
                    builder: (context, adminQuestionProvider, child) {
                  if (adminQuestionProvider.questions.isEmpty) {
                    return const Text('No Questions to show');
                  } else {
                    return QuestionList(
                      context: context,
                      questions: adminQuestionProvider.questions,
                    );
                  }
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showQuestionBottomSheet(BuildContext context) {
    Question _question =
        Question(statement: '', options: List.generate(4, (index) => ''));
    List<int> _options =
        List.generate(_question.options!.length, (index) => index);
    int? _value = _question.answer;
    showModalBottomSheet(
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Consumer<AdminQuestionProvider>(
                      builder: (context, adminQuestionProvider, child) {
                    return adminQuestionProvider.addQuestionLoading
                        ? const LinearProgressIndicator()
                        : const SizedBox();
                  }),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 38.0),
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        const Expanded(
                            child: Center(child: Text('Add a Question'))),
                        Expanded(
                            child: IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline_rounded,
                            size: 30,
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            bool res = await Provider.of<AdminQuestionProvider>(
                                    context,
                                    listen: false)
                                .addQuestion(
                                    Provider.of<AdminProvider>(context,
                                            listen: false)
                                        .admin!,
                                    _question);
                            if (!res) {
                              showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: SizedBox(
                                          height: 100,
                                          child: Column(
                                            children: [
                                              Align(
                                                  alignment: Alignment.topRight,
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Icon(Icons
                                                          .cancel_outlined))),
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Error Occurred',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Statement: '),
                      SizedBox(
                        width: 400,
                        child: TextField(
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {
                              _question.statement = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: 500,
                    child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, mainAxisExtent: 50),
                        itemCount: _question.options != null
                            ? _question.options!.length
                            : 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Option ${index + 1}: '),
                              SizedBox(
                                width: 120,
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      _question.options![index] = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Select Answer: '),
                      StatefulBuilder(builder: (context, setState) {
                        return DropdownButton<int>(
                            value: _value,
                            items: _options.map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text('${value + 1}'),
                              );
                            }).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                _value = value;
                                _question.answer = value;
                                debugPrint('new value $_value');
                              });
                            });
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ));
  }
}
