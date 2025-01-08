import 'package:intl/intl.dart';

class DateTimeUtil {
  static const String serverDateTimeFormat = "yyyy-MM-ddTHH:mm:ss";
  static const String localTimeFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS";
  static const String dateTimeFormat1 = "dd/MMM/yyyy";
  static const String dateTimeFormat2 = "dd MMM yyyy";
  static const String dateTimeFormat3 = "dd-MM-yyyy";
  static const String dateTimeFormat4 = "yyyy-MM-dd";
  static const String dateTimeFormat5 = "EE, MMM dd, yyyy";
  static const String dateTimeFormat6 = "MMMM yyyy";
  static const String dateTimeFormat7 = "EEE";
  static const String dateTimeFormat8 = "dd";
  static const String dateTimeFormat9 = "hh:mm a";
  static const String dateTimeFormat10 = "EEE";
  static const String dateTimeFormat11 = "HH:mm:ss";

  static String formatDate(
    String? date, {
    String inputDateTimeFormat = serverDateTimeFormat,
    String outputDateTimeFormat = dateTimeFormat1,
  }) {
    if (date == null) return "";

    try {
      DateTime tempDate = DateFormat(inputDateTimeFormat).parse(date);
      return DateFormat(outputDateTimeFormat).format(tempDate);
    } on Exception catch (e) {
      print("Error parsing date time: $e");
      return "";
    }
  }

  static String parseDateTime(String date,String formatIn,String formatOut,{bool isutc=false,}){
    DateTime dateTime=isutc?DateFormat(formatIn).parse(date,isutc,).toLocal():
    DateFormat(formatIn).parse(date,isutc,);
    return DateFormat(formatOut).format(dateTime);
  }

  static String formatDateInUTC(
      String? date, {
        String inputDateTimeFormat = serverDateTimeFormat,
        String outputDateTimeFormat = dateTimeFormat1,
      }) {
    if (date == null) return "";

    try {
      DateTime tempDate = DateFormat(inputDateTimeFormat).parse(date).toUtc();
      return DateFormat(outputDateTimeFormat).format(tempDate);
    } on Exception catch (e) {
      print("Error parsing date time: $e");
      return "";
    }
  }

  static String formatDateTime(
    DateTime? date, {
    String outputDateTimeFormat = dateTimeFormat1,
  }) {
    if (date == null) return "";

    return DateFormat(outputDateTimeFormat).format(date);
  }

  static DateTime stringToDate(
    String? date, {
    String? outputDateTimeFormat,
  }) {
    if (date == null) return DateTime.now();

    if (outputDateTimeFormat == null) {
      return DateTime.parse(date);
    }

    return DateFormat(outputDateTimeFormat).parse(date);
  }

  static bool areHoursAndMinutesEqual(DateTime dateTime1, DateTime dateTime2) {
    // Extract the hour and minute components from the DateTime objects
    int hour1 = dateTime1.hour;
    int minute1 = dateTime1.minute;
    int hour2 = dateTime2.hour;
    int minute2 = dateTime2.minute;

    // Check if the hours and minutes are the same
    return hour1 == hour2 && minute1 == minute2;
  }

  static DateTime getCurrentDate() {
    var now = DateTime.now();
    DateTime currentDate = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    return currentDate;
  }

  static DateTime getLastDayOfMonth(DateTime month) {
    DateTime firstDayOfMonth = DateTime(month.year, month.month);
    DateTime nextMonth = firstDayOfMonth.add(const Duration(days: 32));
    DateTime firstDayOfNextMonth = DateTime(nextMonth.year, nextMonth.month);
    return firstDayOfNextMonth.subtract(const Duration(days: 1));
  }

  static String convertTo12HourFormat(String? time24Hour) {
    if (time24Hour == null) return "";

    final DateFormat formatter24Hour = DateFormat('HH:mm');
    final DateFormat formatter12Hour = DateFormat('h:mm a');
    final DateTime dateTime = formatter24Hour.parse(time24Hour);
    return formatter12Hour.format(dateTime);
  }

  static bool greater(DateTime date1, DateTime date2) {
    return date1.isAfter(date2);
  }

  static String timeAgoSinceDate(String createAt, {bool numericDates = true}) {
    // 2022-07-08T15:37:16.000+00:00
    // 2024-02-13T17:48:23.169Z
    print(createAt);
    try {
      DateTime date = DateFormat(serverDateTimeFormat).parse(createAt, true).toLocal();
      final date2 = DateTime.now().toLocal();
      final difference = date2.difference(date);

      if (difference.inSeconds < 5) {
        return 'Just now';
      } else if (difference.inSeconds <= 60) {
        return '${difference.inSeconds} s ago';
      } else if (difference.inMinutes <= 1) {
        return (numericDates) ? '1m ago' : 'A minute ago';
      } else if (difference.inMinutes <= 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours <= 1) {
        return (numericDates) ? '1h ago' : 'An hour ago';
      } else if (difference.inHours <= 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays <= 1) {
        return (numericDates) ? '1d ago' : 'Yesterday';
      } else if (difference.inDays <= 6) {
        return '${difference.inDays}d ago';
      } else if ((difference.inDays / 7).ceil() <= 1) {
        return (numericDates) ? '1w ago' : 'Last week';
      } else if ((difference.inDays / 7).ceil() <= 4) {
        return '${(difference.inDays / 7).ceil()}w ago';
      } else if ((difference.inDays / 30).ceil() <= 1) {
        return (numericDates) ? '1month ago' : 'Last month';
      } else if ((difference.inDays / 30).ceil() <= 30) {
        return '${(difference.inDays / 30).ceil()}months ago';
      } else if ((difference.inDays / 365).ceil() <= 1) {
        return (numericDates) ? '1y ago' : 'Last year';
      }
      return '${(difference.inDays / 365).floor()}yrs ago';
    } catch (e) {
      return "";
    }
  }
  static String timeAgoSinceDateFirebase(DateTime dateTime, {bool numericDates = true}) {
    // 2022-07-08T15:37:16.000+00:00
    // 2024-02-13T17:48:23.169Z
    try {
      final date2 = DateTime.now().toLocal();
      final difference = date2.difference(dateTime);

      if (difference.inSeconds < 5) {
        return 'Just now';
      } else if (difference.inSeconds <= 60) {
        return '${difference.inSeconds} s ago';
      } else if (difference.inMinutes <= 1) {
        return (numericDates) ? '1m ago' : 'A minute ago';
      } else if (difference.inMinutes <= 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours <= 1) {
        return (numericDates) ? '1h ago' : 'An hour ago';
      } else if (difference.inHours <= 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays <= 1) {
        return (numericDates) ? '1d ago' : 'Yesterday';
      } else if (difference.inDays <= 6) {
        return '${difference.inDays}d ago';
      } else if ((difference.inDays / 7).ceil() <= 1) {
        return (numericDates) ? '1w ago' : 'Last week';
      } else if ((difference.inDays / 7).ceil() <= 4) {
        return '${(difference.inDays / 7).ceil()}w ago';
      } else if ((difference.inDays / 30).ceil() <= 1) {
        return (numericDates) ? '1month ago' : 'Last month';
      } else if ((difference.inDays / 30).ceil() <= 30) {
        return '${(difference.inDays / 30).ceil()}months ago';
      } else if ((difference.inDays / 365).ceil() <= 1) {
        return (numericDates) ? '1y ago' : 'Last year';
      }
      return '${(difference.inDays / 365).floor()}yrs ago';
    } catch (e) {
      return "";
    }
  }

  static DateTime getDateOnly(DateTime dateTimeObj) {
    return DateTime(dateTimeObj.year, dateTimeObj.month, dateTimeObj.day);
  }

  static bool isDateBefore(date1, date2) {
    DateTime date10 = DateTime(date1.year, date1.month, date1.day);
    DateTime date20 = DateTime(date2.year, date2.month, date2.day);
    return date10.isBefore(date20);
  }

  static bool isDateAfter(date1, date2) {
    DateTime date10 = DateTime(date1.year, date1.month, date1.day);
    DateTime date20 = DateTime(date2.year, date2.month, date2.day);
    return date10.isAfter(date20);
  }
}
