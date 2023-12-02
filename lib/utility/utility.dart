class Utility {
  static String DateTimeToString(DateTime dateTime) {
    String daySuffix = getDaySuffix(dateTime.day);
    String month = getMonthName(dateTime.month);
    int year = dateTime.year;

    return '${dateTime.day}$daySuffix $month, $year';
  }

  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String getMonthName(int month) {
    const List<String> months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[month];
  }
}
