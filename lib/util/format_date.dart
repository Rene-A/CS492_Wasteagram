
import 'package:intl/intl.dart';

// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html

String fullMonthDayYear(DateTime dateTime) {

  return DateFormat.yMMMMd().format(dateTime).toString();
}

String fullWeekdayMonthDayYear(DateTime dateTime) {

  String weekday = DateFormat.EEEE().format(dateTime).toString();
  return '$weekday, ${fullMonthDayYear(dateTime)}';
}

