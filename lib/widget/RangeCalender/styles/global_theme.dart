import 'package:flutter/material.dart';
import 'package:yl_flutter_components/components/calendar/yl_calendar.dart';

class GlobalTheme {
  static void init() {
    ///设置日历组件的全局样式
    var style = YLCalendarStyle()
      ..beforeIcon = Image.asset(
        'images/icon/icon_calendar_left.png',
        width: 18,
        height: 18,
      )
      ..disabledBeforeIcon = Opacity(
        opacity: 0.7,
        child: Image.asset(
          'images/icon/icon_calendar_left.png',
          width: 18,
          height: 18,
        ),
      )
      ..nextIcon = Image.asset(
        'images/icon/icon_calendar_right.png',
        width: 18,
        height: 18,
      )
      ..disabledNextIcon = Opacity(
        opacity: 0.7,
        child: Image.asset(
          'images/icon/icon_calendar_right.png',
          width: 18,
          height: 18,
        ),
      )
      ..buttonStyle = const ButtonStyle(
        foregroundColor: MaterialStatePropertyAll(Color(0xFF61666D)),
        textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 14)),
        overlayColor: MaterialStatePropertyAll(Colors.white),
      );
    YLCalendarGlobalStyle().style = style;
  }
}
