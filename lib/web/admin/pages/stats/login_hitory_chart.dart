import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:monopoly/models/time_series_login.dart';
import 'package:charts_flutter/src/text_element.dart' as TextElement;
import 'package:charts_flutter/src/text_style.dart' as style;

String? _title;

String? _subTitle;

class ToolTipMgr {
  static String? get title => _title;

  static String? get subTitle => _subTitle;

  static setTitle(Map<String, dynamic> data) {
    if (data['title'] != null && data['title'].length > 0) {
      _title = data['title'];
    }

    if (data['subTitle'] != null && data['subTitle'].length > 0) {
      _subTitle = data['subTitle'];
    }
  }
}

class LoginHistoryChart extends StatelessWidget {
  final List<charts.Series<TimeSeriesLogin, DateTime>> seriesList;
  final bool animate;

  const LoginHistoryChart(
      {required this.animate, Key? key, required this.seriesList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: charts.TimeSeriesChart(seriesList,
          animate: animate,
          // Set the default renderer to a bar renderer.
          // This can also be one of the custom renderers of the time series chart.
          defaultRenderer: charts.BarRendererConfig<DateTime>(),
          // It is recommended that default interactions be turned off if using bar
          // renderer, because the line point highlighter is the default for time
          // series chart.
          defaultInteractions: false,
          // If default interactions were removed, optionally add select nearest
          // and the domain highlighter that are typical for bar charts.
          behaviors: [
            charts.LinePointHighlighter(
                symbolRenderer: CustomCircleSymbolRenderer()),
            charts.SelectNearest(
                eventTrigger: charts.SelectionTrigger.tapAndDrag),
            charts.PanAndZoomBehavior(),
          ],
          selectionModels: [
            charts.SelectionModelConfig(
                changedListener: (charts.SelectionModel model) {
              if (model.hasDatumSelection) {
                ToolTipMgr.setTitle({
                  'title': model.selectedSeries[0]
                              .measureFn(model.selectedDatum[0].index)! >
                          1
                      ? '${model.selectedSeries[0].measureFn(model.selectedDatum[0].index)} users'
                      : '${model.selectedSeries[0].measureFn(model.selectedDatum[0].index)} user',
                  'subTitle': '111133'
                });
//            print(${model.selectedSeries[0].measureFn(model.selectedDatum[0].datum.year)});
              }
            })
          ]),
    );
  }
}

class CustomCircleSymbolRenderer extends CircleSymbolRenderer {
  double height = 20;

  @override
  void paint(ChartCanvas canvas, Rectangle<num> bounds,
      {List<int>? dashPattern,
      Color? fillColor,
      FillPatternType? fillPattern,
      Color? strokeColor,
      double? strokeWidthPx}) {
    super.paint(canvas, bounds,
        dashPattern: dashPattern,
        fillColor: fillColor,
        strokeColor: strokeColor,
        strokeWidthPx: strokeWidthPx);
    canvas.drawRect(
        Rectangle(bounds.left - 5, bounds.top, bounds.width + 100,
            bounds.height + 10),
        fill: Color.white);

    style.TextStyle textStyle = style.TextStyle();

    textStyle.color = Color.black;
    textStyle.fontSize = 15;

    canvas.drawText(
        TextElement.TextElement(ToolTipMgr.title!, style: textStyle),
        (bounds.left).round(),
        (bounds.top + 2).round());
  }
}
