import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/providers/admin_provider.dart';
import 'package:monopoly/providers/feedback_provider.dart';
import 'package:monopoly/web/admin/pages/feedback/feedback_data_source.dart';
import 'package:provider/provider.dart';

class FeedbackList extends StatelessWidget {
  const FeedbackList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);

    return ChangeNotifierProvider(
      create: (context) => FeedbackProvider.admin(adminProvider.admin!),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Consumer<FeedbackProvider>(
                    builder: (context, feedbackProvider, child) {
                  return feedbackProvider.feedbackLoading ||
                          feedbackProvider.feedbackPaginationLoading
                      ? const LinearProgressIndicator()
                      : const SizedBox();
                }),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Consumer<FeedbackProvider>(
                builder: (context, feedbackProvider, child) {
              return ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: PaginatedDataTable(
                  source: FeedbackDataSource(
                      feedbacks: feedbackProvider.feedbacks, context: context),
                  //    header: const Text('My Products'),
                  columns: const [
                    DataColumn(label: Text('#')),
                    DataColumn(label: Text('Reason')),
                    DataColumn(label: Text('E-mail')),
                    DataColumn(label: Text('Message')),
                  ],
                  columnSpacing: 100,
                  horizontalMargin: 10,
                  rowsPerPage: 8,
                  showCheckboxColumn: false,

                  availableRowsPerPage: const [20],

                  onPageChanged: (number) {
                    debugPrint(number.toString());
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
