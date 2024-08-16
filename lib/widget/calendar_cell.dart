import 'package:flutter/material.dart';
import 'package:yl_flutter_components/components/calendar/yl_calendar.dart';
import 'package:ui_kit/color_style.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    required this.selectTime,
    required this.callBack,
    Key? key,
  }) : super(key: key);
  final void Function(DateTime?)? callBack;
  final String selectTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width:0.5, color: ColorStyle.borderColor1)),
      ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 220,
        height: 40,
        child: YLCalendar(
          mode: YLCalendarMode.day,
          date: DateTime.tryParse(selectTime),
          onChange: callBack,
        ),
      ),
    );
  }
}
