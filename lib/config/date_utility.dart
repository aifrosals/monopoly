import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtility {
  static String formatDateFromString(String date) {
    DateTime? dateTime = DateTime.tryParse(date);
    debugPrint('config date $date');
    var format = DateFormat('yyyy-MM-dd');
    String formattedDate = dateTime != null ? format.format(dateTime) : '';
    debugPrint(formattedDate);
    return formattedDate;
  }
}
