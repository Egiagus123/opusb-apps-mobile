import 'package:intl/intl.dart';

class Formatter {
  static String formatNumber(num number) {
    return NumberFormat('#,###').format(number);
  }

  static num parseNumber(String number) {
    return NumberFormat('#,###').parse(number);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('yMd').format(dateTime);
  }

  static DateTime parseDate(String dateTime) {
    return DateFormat('yMd').parse(dateTime);
  }
}
