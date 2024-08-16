import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/calendar/index.dart';
import 'package:ui_kit/widget/calendar_cell.dart';
import 'package:ui_kit/utils/common.dart';

/// flutter 自带的日期选择器
@UseCase(
  name: 'showDatePicker',
  type: DatePickerDialog,
)
Widget buildFlanRangeCalendarUseCase(BuildContext context) {
  return InkWell(
    onTap: () {
      final times = '2010-10';
      final lastDate = 0;
      showDatePicker(
        context: context,
        initialDate:
            DateTime.parse(times.length != 10 ? "$times-01" : times), //选中的日期
        firstDate: DateTime(1900), //日期选择器上可选择的最早日期
        lastDate: lastDate == 0
            ? DateTime.now()
            : Common.calcTimeDate(lastDate), //日期选择器上可选择的最晚日期
      ).then((result) {
        print('---->date picker: ${result.toString()}');
      });
    },
    child: Text(
      'Show Picker',
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 19,
      ),
    ),
  );
}

@UseCase(
  name: 'CalendarRange',
  type: FlanRangeCalendar,
)
Widget buildDatePickerCalendarUseCase(BuildContext context) {
  return CalendarRange(
    maxRange: 10,
    textSize: 14,
    iconSpacing: 1,
  );
}

@UseCase(
  name: 'YLCalendar',
  type: CalendarCell,
)
Widget buildCalendarCellUseCase(BuildContext context) {
  return CalendarCell(
    selectTime: '2020-10-10',
    callBack: (datetime) {
      print('---->datetime: ${datetime.toString()}');
    },
  );
}
