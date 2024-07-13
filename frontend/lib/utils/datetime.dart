import 'package:intl/intl.dart';

String formatDateTimeToLocale(DateTime dateTime) {
  DateTime utcDateTime = dateTime.toUtc();
  DateTime jaDateTime = utcDateTime.add(const Duration(hours: 9));
  DateFormat outputFormat = DateFormat('yyyy年MM月dd日HH時mm分');
  return outputFormat.format(jaDateTime);
}
