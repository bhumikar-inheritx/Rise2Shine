import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String format(String pattern) => DateFormat(pattern).format(this);

  String get formatDate => format('dd/MM/yyyy');

  String get formatTime => format('HH:mm');

  String get formatDateTime => format('dd/MM/yyyy HH:mm');

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
