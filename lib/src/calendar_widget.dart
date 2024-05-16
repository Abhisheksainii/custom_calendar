import 'package:flutter/material.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _currentDateTime = DateTime.now();

  final _controller = PageController(initialPage: DateTime.now().month);

  int currentIndex = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kBorderColor),
      ),
      height: 470,
      child: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          MonthYearHeader(
            currentDateTime: _currentDateTime,
            pageController: _controller,
          ),
          const SizedBox(
            height: 5,
          ),
          Divider(
            color: AppColors.kBorderColor,
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
              itemCount: DateTime.now().month + 2,
              onPageChanged: (index) {
                setState(() {
                  _currentDateTime = DateTime(
                    (currentIndex % 12) == 0
                        ? _currentDateTime.year + 1
                        : _currentDateTime.year,
                    index,
                    1,
                  );
                  currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return buildCalendar(_currentDateTime);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.kblueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(50.0)),
                      border: Border.all(
                        color: AppColors.kRed,
                        width: 1.5,
                      ),
                    ),
                    // Pass selected date from the stream or bloc
                    child: Center(
                      child: Text(
                        "${_currentDateTime.day} / ${_currentDateTime.month}",
                        style: TextStyle(
                          color: AppColors.kRed,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Absent",
                    style: TextStyle(
                      color: AppColors.kRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildCalendar(DateTime currentDateTime) {
  final textStyle = const TextStyle(
    fontSize: 11,
  );
  final daysInCurrentMonth =
      DateTime(currentDateTime.year, currentDateTime.month + 1, 0).day;
  final firstDayofMonth =
      DateTime(currentDateTime.year, currentDateTime.month, 1);
  final weekDayofFirstDay = firstDayofMonth.weekday;

  final daysInPreviousMonth =
      firstDayofMonth.subtract(const Duration(days: 1)).day;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8),
    child: GridView.builder(
      shrinkWrap: true,
      itemCount: daysInCurrentMonth + (weekDayofFirstDay - 1),
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
              currentDateTime.month - 1 == 0 ? 12 : currentDateTime.year - 1;
          final date = DateTime(year, month, prevMonthDay);
          return Padding(
            padding: const EdgeInsets.only(left: 5),
            child: CalendarDateWidget(
              date: date,
              textStyle: textStyle,
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
              isSelected: date.day == DateTime.now().day,
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
    this.dotColor,
    super.key,
  });

  final DateTime date;
  final TextStyle textStyle;
  final String activity;
  final Color? dotColor;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return isSelected
        ? CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.kHomeOrange,
            child: Text(
              date.day.toString(),
              style: textStyle.copyWith(
                color: Colors.white,
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
      backgroundColor: AppColors.kHomeGreen,
    );
  }
}

class MonthYearHeader extends StatelessWidget {
  MonthYearHeader({
    required this.currentDateTime,
    required this.pageController,
    super.key,
  });

  final DateTime currentDateTime;
  final PageController pageController;

  final lastSecondMonthDateTime = DateTime(
    DateTime.now().year,
    DateTime.now().month - 2,
    DateTime.now().day,
  );
  bool movePrev() {
    return currentDateTime.month - 1 != lastSecondMonthDateTime.month;
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
              if (pageController.page! > 0 && movePrev()) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppColors.kDarkBlue,
              size: 18,
            ),
          ),
          Text(
            "${DateFormat("MMMM").format(currentDateTime)} ${DateFormat("y").format(currentDateTime)}",
            style: TextStyle(
              color: AppColors.kDarkBlue,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          InkWell(
            onTap: () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColors.kDarkBlue,
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
