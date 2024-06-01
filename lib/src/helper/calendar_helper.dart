extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBeforeMonth(DateTime other) {
    if (year < other.year) {
      return true;
    }
    if (year > other.year) {
      return false;
    }
    if (month < other.month) {
      return true;
    }
    return false;
  }

  bool isAfterMonth(DateTime other) {
    if (year > other.year) {
      return true;
    }
    if (year < other.year) {
      return false;
    }
    if (month > other.month) {
      return true;
    }
    return false;
  }
}
