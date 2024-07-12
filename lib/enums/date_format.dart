import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class DateFormatVN {
  static void initializeTimeAgo() {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
  }

  static String formatDate(String dateString) {
    DateFormat dateFormat = DateFormat('d MMMM', 'vi');
    return dateFormat.format(DateTime.parse(dateString));
  }

  static String timeAgo(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return timeago.format(date, locale: 'vi');
  }

  static String formatTime(String dateString) {
    DateFormat timeFormat = DateFormat('HH:mm', 'vi');
    return timeFormat.format(DateTime.parse(dateString));
  }

  static String formatDateDDMM(String dateString) {
    DateFormat dateFormat = DateFormat('dd/MM', 'vi');
    return dateFormat.format(DateTime.parse(dateString));
  }
}

class ViMessages implements timeago.LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => 'trước';
  @override
  String suffixFromNow() => 'từ bây giờ';
  @override
  String lessThanOneMinute(int seconds) => 'vài giây';
  @override
  String aboutAMinute(int minutes) => 'một phút';
  @override
  String minutes(int minutes) => '$minutes phút';
  @override
  String aboutAnHour(int minutes) => 'một giờ';
  @override
  String hours(int hours) => '$hours giờ';
  @override
  String aDay(int hours) => 'một ngày';
  @override
  String days(int days) => '$days ngày';
  @override
  String aboutAMonth(int days) => 'một tháng';
  @override
  String months(int months) => '$months tháng';
  @override
  String aboutAYear(int year) => 'một năm';
  @override
  String years(int years) => '$years năm';
  @override
  String wordSeparator() => ' ';
}
