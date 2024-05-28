// ignore_for_file: prefer_const_constructors

import 'package:custom_calendar/src/helper/calendar_helper.dart';
import 'package:custom_calendar/src/model/calendar_data_model.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    required this.startDate,
    required this.endDate,
    required this.enableVerticalScroll,
    required this.calendarData,
    required this.onTap,
    super.key,
  });
  final DateTime startDate;
  final DateTime endDate;
  final void Function(DateTime date)? onTap;
  final bool enableVerticalScroll;
  final List<CalendarDataModel> calendarData;

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentDateTime;

  late final PageController _controller;

  late int _currentIndex;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
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
                final daysInCurrentMonth = DateTime(
                  _currentDateTime.year,
                  _currentDateTime.month + 1,
                  0,
                ).day;
                final firstDayofMonth = DateTime(
                  _currentDateTime.year,
                  _currentDateTime.month,
                  1,
                );
                final weekDayofFirstDay = firstDayofMonth.weekday;

                final daysInPreviousMonth =
                    firstDayofMonth.subtract(const Duration(days: 1)).day;
                return CalendarGrid(
                  verticalScrollEnabled: widget.enableVerticalScroll,
                  calendarData: widget.calendarData,
                  currentDateTime: _currentDateTime,
                  selectedDate: _selectedDate,
                  pageController: _controller,
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  onTap: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                    widget.onTap?.call(date);
                  },
                  firstDayofMonth: firstDayofMonth,
                  daysInCurrentMonth: daysInCurrentMonth,
                  daysInPreviousMonth: daysInPreviousMonth,
                  weekDayofFirstDay: weekDayofFirstDay,
                );
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

class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    required this.currentDateTime,
    required this.selectedDate,
    required this.startDate,
    required this.endDate,
    required this.calendarData,
    required this.onTap,
    required this.verticalScrollEnabled,
    required this.firstDayofMonth,
    required this.daysInCurrentMonth,
    required this.daysInPreviousMonth,
    required this.weekDayofFirstDay,
    required this.pageController,
    super.key,
  });

  final DateTime currentDateTime;
  final DateTime firstDayofMonth;
  final DateTime selectedDate;
  final DateTime startDate;
  final DateTime endDate;
  final List<CalendarDataModel> calendarData;
  final void Function(DateTime date) onTap;
  final bool verticalScrollEnabled;
  final int daysInCurrentMonth;
  final int daysInPreviousMonth;
  final int weekDayofFirstDay;
  final PageController pageController;

  static const textStyle = TextStyle(
    fontSize: 11,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: !verticalScrollEnabled ? NeverScrollableScrollPhysics() : null,
        itemCount: daysInCurrentMonth + (weekDayofFirstDay - 1),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 14,
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
            final calendardata = calendarData
                .firstWhere((element) => element.date.isSameDate(date));
            return Padding(
              padding: const EdgeInsets.only(left: 5),
              child: CalendarDateWidget(
                date: date,
                textStyle: textStyle,
                dotColor: calendardata.color ?? Colors.transparent,
                activity: calendardata.text ?? "",
                onTap: (date) {
                  _pageChangeOnDateTap(date, currentDateTime, pageController);
                  onTap.call(date);
                },
                enabled: !date.isBefore(startDate) && !date.isAfter(endDate),
              ),
            );
          } else {
            final text = index - weekDayofFirstDay + 2;
            final date =
                DateTime(currentDateTime.year, currentDateTime.month, text);
            final calendardata = calendarData
                .firstWhere((element) => element.date.isSameDate(date));
            return Padding(
              padding: const EdgeInsets.only(left: 3),
              child: CalendarDateWidget(
                isSelected: date.day == selectedDate.day &&
                    date.month == selectedDate.month &&
                    date.year == selectedDate.year,
                isToday: date.day == DateTime.now().day &&
                    date.month == DateTime.now().month &&
                    date.year == DateTime.now().year,
                date: date,
                dotColor: calendardata.color ?? Colors.transparent,
                activity: calendardata.text ?? "",
                textStyle: textStyle,
                enabled: !date.isBefore(startDate) && !date.isAfter(endDate),
                onTap: (date) {
                  _pageChangeOnDateTap(date, currentDateTime, pageController);
                  onTap.call(date);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

void _pageChangeOnDateTap(
    DateTime date, DateTime currentDateTime, PageController pageController) {
  if (date.year == currentDateTime.year) {
    if (date.month < currentDateTime.month) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else if (date.month > currentDateTime.month) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  if (date.year < currentDateTime.year) {
    pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  if (date.year > currentDateTime.year) {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

class CalendarDateWidget extends StatelessWidget {
  const CalendarDateWidget({
    required this.date,
    required this.textStyle,
    required this.activity,
    required this.onTap,
    this.isSelected = false,
    this.isToday = false,
    this.dotColor,
    this.enabled = true,
    super.key,
  });

  final DateTime date;
  final TextStyle textStyle;
  final String activity;
  final Color? dotColor;
  final bool isSelected;
  final void Function(DateTime date) onTap;
  final bool isToday;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled
          ? () {
              onTap.call(date);
            }
          : null,
      child: isSelected
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
              ? Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 30,
                    child: Text(
                      date.day.toString(),
                      style: textStyle.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Text(
                      date.day.toString(),
                      style: textStyle.copyWith(
                        color: enabled ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    if (!isSelected && enabled && dotColor != null)
                      Dot(
                        color: dotColor ?? Colors.transparent,
                      ),
                    if (enabled)
                      const SizedBox(
                        height: 2,
                      ),
                    if (enabled)
                      Text(
                        activity.isEmpty ? "" : activity,
                        textAlign: TextAlign.center,
                        style: textStyle.copyWith(fontSize: 9),
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
    if (currentDateTime.year > startDate.year) {
      return true;
    }
    if (currentDateTime.year == startDate.year &&
        currentDateTime.month > startDate.month) {
      return true;
    }

    return false;
  }

  bool _nextEnabled() {
    if (currentDateTime.year < endDate.year) {
      return true;
    }
    if (currentDateTime.year == endDate.year &&
        currentDateTime.month < endDate.month) {
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
          Visibility(
            visible: _prevEnabled(),
            child: InkWell(
              onTap: () {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(
                Icons.arrow_back_ios,
                // color grey if disabled
                color: Color(0xFF072A72),
                size: 18,
              ),
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
          Visibility(
            visible: _nextEnabled(),
            child: InkWell(
              onTap: () {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF072A72),
                size: 18,
              ),
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
