import 'package:flutter/material.dart';
import 'package:monopoly/models/feedback.dart' as feedback;

class FeedbackDataSource extends DataTableSource {
  final List<feedback.Feedback> feedbacks;
  final BuildContext context;

  FeedbackDataSource({
    required this.feedbacks,
    required this.context,
  });

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => feedbacks.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(
        onSelectChanged: (value) {
          showDialog(
              context: context,
              builder: (context) => Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Message',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                              'From ${feedbacks[index].email} for ${feedbacks[index].type}',
                              textAlign: TextAlign.center),
                          const SizedBox(height: 5),
                          Text(feedbacks[index].message,
                              textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  ));
        },
        cells: [
          DataCell(Text('${index + 1}')),
          DataCell(Text(feedbacks[index].type)),
          DataCell(Text(feedbacks[index].email)),
          DataCell(SizedBox(
              width: 200,
              child: Text(
                feedbacks[index].message,
                overflow: TextOverflow.ellipsis,
              ))),
        ]);
  }
}
