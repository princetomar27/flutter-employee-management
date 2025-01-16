import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toTimeFormat() {
    return DateFormat('hh:mm a').format(this);
  }

  String toDayOfWeek() {
    return DateFormat('EEEE').format(this);
  }

  String toFullDate() {
    return DateFormat('MMM dd, yyyy').format(this);
  }
}
