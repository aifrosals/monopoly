/// Example of a time series chart using a bar renderer.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class TimeSeriesBar extends StatelessWidget {
  final List<charts.Series<TimeSeriesSales, DateTime>> seriesList;
  final bool animate;

  const TimeSeriesBar(
      {required this.animate, Key? key, required this.seriesList});

  /// Creates a [TimeSeriesChart] with sample data and no transition.
  factory TimeSeriesBar.withSampleData() {
    return TimeSeriesBar(

      seriesList:
      _createSampleData(),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: new charts.TimeSeriesChart(
        seriesList,
        animate: animate,
        // Set the default renderer to a bar renderer.
        // This can also be one of the custom renderers of the time series chart.
        defaultRenderer: new charts.BarRendererConfig<DateTime>(),
        // It is recommended that default interactions be turned off if using bar
        // renderer, because the line point highlighter is the default for time
        // series chart.
        defaultInteractions: false,
        // If default interactions were removed, optionally add select nearest
        // and the domain highlighter that are typical for bar charts.
        behaviors: [new charts.SelectNearest(), new charts.DomainHighlighter()],
      ),
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      TimeSeriesSales(DateTime(2017, 9, 1), 5),
      TimeSeriesSales(DateTime(2017, 9, 2), 5),
      TimeSeriesSales(DateTime(2017, 9, 3), 25),
      TimeSeriesSales(DateTime(2017, 9, 4), 100),
      TimeSeriesSales(DateTime(2017, 9, 5), 75),
      TimeSeriesSales(DateTime(2017, 9, 6), 88),
      TimeSeriesSales(DateTime(2017, 9, 7), 65),
      TimeSeriesSales(DateTime(2017, 9, 8), 91),
      TimeSeriesSales(DateTime(2017, 9, 9), 100),
      TimeSeriesSales(DateTime(2017, 9, 10), 111),
      TimeSeriesSales(DateTime(2017, 9, 11), 90),
      TimeSeriesSales(DateTime(2017, 9, 12), 50),
      TimeSeriesSales(DateTime(2017, 9, 13), 40),
      TimeSeriesSales(DateTime(2017, 9, 14), 30),
      TimeSeriesSales(DateTime(2017, 9, 15), 40),
      TimeSeriesSales(DateTime(2017, 9, 16), 50),
      TimeSeriesSales(DateTime(2017, 9, 17), 30),
      TimeSeriesSales(DateTime(2017, 9, 18), 35),
      TimeSeriesSales(DateTime(2017, 9, 19), 40),
      TimeSeriesSales(DateTime(2017, 9, 20), 32),
      TimeSeriesSales(DateTime(2017, 9, 21), 31),
    ];

    return [
      charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}