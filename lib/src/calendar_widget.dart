// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    required this.startDate,
    required this.endDate,
    super.key,
  });
  final DateTime startDate;
  final DateTime endDate;
  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentDateTime;

  late final PageController _controller;

  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    // to implement function for current index if end date goes above current date
    _currentIndex =
        _totalMonths(startDate: widget.startDate, endDate: widget.endDate) -
            _totalMonths(startDate: DateTime.now(), endDate: widget.endDate);
    _controller = PageController(initialPage: _currentIndex);

    _currentDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xFFCCCCCC)),
      ),
      height: 500,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          MonthYearHeader(
            currentDateTime: _currentDateTime,
            pageController: _controller,
            startDate: widget.startDate,
            endDate: widget.endDate,
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: Color(0xFFCCCCCC),
          ),
          const SizedBox(
            height: 10,
          ),
          WeekHeader(),
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: _totalMonths(
                startDate: widget.startDate,
                endDate: widget.endDate,
              ),
              onPageChanged: (index) {
                setState(() {
                  _currentDateTime = _getChangedMonth(
                    currentDate: _currentDateTime,
                    currentIndex: _currentIndex,
                    index: index,
                  );
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return buildCalendar(_currentDateTime);
              },
            ),
          ),
        ],
      ),
    );
  }
}

DateTime _getChangedMonth({
  required int currentIndex,
  required int index,
  required DateTime currentDate,
}) {
  if (index < currentIndex) {
    if (currentDate.month == 1) {
      return DateTime(
        currentDate.year - 1,
        12,
        1,
      );
    } else {
      return DateTime(
        currentDate.year,
        currentDate.month - 1,
        1,
      );
    }
  } else {
    if (currentDate.month == 12) {
      return DateTime(
        currentDate.year + 1,
        1,
        1,
      );
    } else {
      return DateTime(
        currentDate.year,
        currentDate.month + 1,
        1,
      );
    }
  }
}

int _totalMonths({required DateTime startDate, required DateTime endDate}) {
  return ((endDate.year - startDate.year) * 12 +
      ((endDate.month - startDate.month) + 1));
}

Widget buildCalendar(DateTime currentDateTime) {
  final textStyle = TextStyle(
    fontSize: 11,
  );
  final daysInCurrentMonth =
      DateTime(currentDateTime.year, currentDateTime.month + 1, 0).day;
  final firstDayofMonth =
      DateTime(currentDateTime.year, currentDateTime.month, 1);
  final weekDayofFirstDay = firstDayofMonth.weekday;
  final lastDayofMonth =
      DateTime(currentDateTime.year, currentDateTime.month + 1, 0);
  final weekDayofLastDay = lastDayofMonth.weekday;

  final daysInPreviousMonth =
      firstDayofMonth.subtract(const Duration(days: 1)).day;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.builder(
      shrinkWrap: true,
      itemCount:
          daysInCurrentMonth + (weekDayofFirstDay - 1) + (7 - weekDayofLastDay),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 15,
        crossAxisCount: 7,
      ),
      itemBuilder: (context, index) {
        if (index < weekDayofFirstDay - 1) {
          final prevMonthDay =
              daysInPreviousMonth - (weekDayofFirstDay - index - 1) + 1;
          final year = currentDateTime.month - 1 == 0
              ? currentDateTime.year - 1
              : currentDateTime.year;
          final month =
              currentDateTime.month - 1 == 0 ? 12 : currentDateTime.month - 1;
          final date = DateTime(year, month, prevMonthDay);
          return Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CalendarDateWidget(
              date: date,
              textStyle: TextStyle(color: Colors.grey),
              activity: "activity",
            ),
          );
        } else {
          final text = index - weekDayofFirstDay + 2;
          final date =
              DateTime(currentDateTime.year, currentDateTime.month, text);
          return Padding(
            padding: const EdgeInsets.only(left: 3),
            child: CalendarDateWidget(
              activity: "retialing",
              // selected to be implemented as per usee click
              // initially it is DateTime.now()
              // isSelected: date.day == DateTime.now().day &&
              //     date.month == DateTime.now().month &&
              //     date.year == DateTime.now().year,
              isToday: date.day == DateTime.now().day &&
                  date.month == DateTime.now().month &&
                  date.year == DateTime.now().year,
              date: date,
              textStyle: textStyle,
            ),
          );
        }
      },
    ),
  );
}

class CalendarDateWidget extends StatelessWidget {
  const CalendarDateWidget({
    required this.date,
    required this.textStyle,
    required this.activity,
    this.onTap,
    this.isSelected = false,
    this.isToday = false,
    this.dotColor,
    super.key,
  });

  final DateTime date;
  final TextStyle textStyle;
  final String activity;
  final Color? dotColor;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xffEE6C35),
            child: Text(
              date.day.toString(),
              style: textStyle.copyWith(
                color: Colors.white,
              ),
            ),
          )
        : isToday
            ? CircleAvatar(
                radius: 20,
                child: Text(
                  date.day.toString(),
                  style: textStyle.copyWith(
                    color: Colors.black,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Column(
                  children: [
                    Text(
                      date.day.toString(),
                      style: textStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    if (!isSelected)
                      Dot(
                        color: dotColor ?? Colors.transparent,
                      ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      activity,
                      style: textStyle.copyWith(fontSize: 8),
                    ),
                  ],
                ),
              );
  }
}

class Dot extends StatelessWidget {
  const Dot({
    required this.color,
    super.key,
  });
  final Color color;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 2,
      backgroundColor: Color(0xff4DA430),
    );
  }
}

class MonthYearHeader extends StatelessWidget {
  const MonthYearHeader({
    required this.currentDateTime,
    required this.pageController,
    required this.startDate,
    required this.endDate,
    super.key,
  });

  final DateTime currentDateTime;
  final PageController pageController;
  final DateTime startDate;
  final DateTime endDate;

  bool _prevEnabled() {
    if (currentDateTime.isAfter(startDate)) {
      return true;
    }

    return false;
  }

  bool _nextEnabled() {
    if (currentDateTime.isBefore(endDate)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              if (_prevEnabled()) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              // color grey if disabled
              color: Color(0xFF072A72),
              size: 18,
            ),
          ),
          Text(
            "${DateFormat("MMMM").format(currentDateTime)} ${DateFormat("y").format(currentDateTime)}",
            style: TextStyle(
              color: Color(0xFF072A72),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          InkWell(
            onTap: () {
              if (_nextEnabled()) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF072A72),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class WeekHeader extends StatelessWidget {
  WeekHeader({super.key});

  TextStyle textStyle = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "M",
            style: textStyle,
          ),
          Text(
            "T",
            style: textStyle,
          ),
          Text(
            "W",
            style: textStyle,
          ),
          Text(
            "T",
            style: textStyle,
          ),
          Text(
            "F",
            style: textStyle,
          ),
          Text(
            "S",
            style: textStyle,
          ),
          Text(
            "S",
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
