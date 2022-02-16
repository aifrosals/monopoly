import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/config/screen_config.dart';
import 'package:monopoly/models/question.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/admin_questions_provider.dart';
import 'package:provider/provider.dart';

class QuestionList extends StatefulWidget {
  final List<Question> questions;
  final BuildContext context;

  const QuestionList({Key? key, required this.questions, required this.context})
      : super(key: key);

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    ScreenConfig().init(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: ScreenConfig.screenWidth,
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2)
              },
              children: const [
                TableRow(children: [
                  Text(
                    '#',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('Statement',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Answer', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Results',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Actions',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(4),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2)
                },
                children: widget.questions
                    .asMap()
                    .map(
                      (index, q) => MapEntry(
                        index,
                        TableRow(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: index.isEven
                                  ? Colors.grey[200]
                                  : Colors.white),
                          children: [
                            Text('${index + 1}'),
                            Text(q.statement),
                            Text((q.options != null && q.answer != null)
                                ? q.options![q.answer!]
                                : ""),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Correct Count: ${q.getCorrect()}'),
                                  Text('Incorrect Count: ${q.getIncorrect()}')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Flex(
                                  direction: (ScreenConfig.screenWidth > 640)
                                      ? Axis.horizontal
                                      : Axis.vertical,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.amber,
                                      ),
                                      child: Row(
                                        children: const [
                                          Text('Edit',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.create_rounded,
                                            size: 15,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      onPressed: () =>
                                          _showEditQuestionSheet(context, q),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Row(
                                        children: const [
                                          Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.delete,
                                            size: 15,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      onPressed: () =>
                                          Provider.of<AdminQuestionProvider>(
                                                  context,
                                                  listen: false)
                                              .deleteQuestion(
                                                  Provider.of<AdminProvider>(
                                                          context,
                                                          listen: false)
                                                      .admin!,
                                                  q),
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    )
                    .values
                    .toList()),
          ],
        ),
      ),
    );
  }

  _showEditQuestionSheet(BuildContext context, Question question) {
    List<int> _options =
        List.generate(question.options!.length, (index) => index);
    int? _value = question.answer;
    setState(() {
      debugPrint('question answer $_value ${question.answer}');
    });
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
                            child: Center(child: Text('Edit Question'))),
                        Expanded(
                            child: Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text('Save Changes',
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () async {
                                var res =
                                    await Provider.of<AdminQuestionProvider>(
                                            context,
                                            listen: false)
                                        .updateQuestion(
                                            Provider.of<AdminProvider>(context,
                                                    listen: false)
                                                .admin!,
                                            question);
                                if (res) {
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ],
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
                        child: TextFormField(
                          initialValue: question.statement,
                          maxLines: 3,
                          onChanged: (value) {
                            setState(() {
                              question.statement = value;
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
                        itemCount: question.options != null
                            ? question.options!.length
                            : 4,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Option ${index + 1}: '),
                              SizedBox(
                                width: 120,
                                child: TextFormField(
                                  initialValue: question.options![index],
                                  onChanged: (value) {
                                    setState(() {
                                      question.options![index] = value;
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
                                question.answer = value;
                                debugPrint('new value $_value');
                              });
                            });
                      }),
                    ],
                  )
                ],
              ),
            ));
  }
}
