
import 'dart:math';

import 'package:flutter/material.dart';

import '../RangeCalender/components/calendar.dart';

Future<DatePickerResult?> showRangeCalendar(
  BuildContext context, {
  DateTime? startDateTime,
  DateTime? endDateTime,
  DateTime? minDateTime,
  DateTime? maxDateTime,
      int maxRange = 31,
    }) async {
  return showFlanCalendar(
      context,
      startDateTime: startDateTime,
      endDateTime: endDateTime,
      minDateTime: minDateTime,
      maxDateTime: maxDateTime,
      maxRange: maxRange,
      type: FlanCalendarType.range
  );
}

Future<DatePickerResult?> showFlanCalendar(
    BuildContext context, {
      DateTime? startDateTime,
      DateTime? endDateTime,
      DateTime? minDateTime,
      DateTime? maxDateTime,
      int maxRange = 31,
      FlanCalendarType? type,
    }) async {
  return showDialog(
    context: context,
    builder: (ctx) {
      return Column(
        children: [
          const Expanded(
            flex: 20,
            child: SizedBox(),
          ),
          Flexible(
            flex: 80,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              child: FlanCalendar(
                showExit: true,
                showTitle: true,
                title: '日期选择',
                showSubtitle: false,
                showMark: false,
                allowSameDay: true,
                minDate: minDateTime,
                maxDate: maxDateTime,
                defaultDate: [startDateTime!,endDateTime!],
                maxRange: maxRange,
                type: type!,
                firstDayOfWeek: 7,
                onConfirm: (dateTimes) {
                  Navigator.pop(
                      context,
                      DatePickerResult(
                          startDateTime: dateTimes[0],
                          endDatetime: dateTimes[1]));
                },
              ),
            ),
          ),
        ],
      );
    },
  );
}

/// @DESC: 通过弹窗选择日期范围
/// @PARAMS:
///  - @startDateTime: 起始日期
///  - @endDateTime: 结束日期
///  - @minDateTime: 最小日期
///  - @maxDateTime: 最大日期
///  - @datePickerType: 选择日期类型(年份+月份、年份+月份+日)
Future<DatePickerResult?> showDatePickers(
  BuildContext context, {
  DateTime? startDateTime,
  DateTime? endDateTime,
  DateTime? minDateTime,
  DateTime? maxDateTime,
  DatePickerType datePickerType = DatePickerType.Y_M_D,
}) async {
  return showModalBottomSheet<DatePickerResult>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8),
        ),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                _DatePickerView(
                  startDateTime: startDateTime,
                  endDateTime: endDateTime,
                  minDateTime: minDateTime ?? DateTime(1900),
                  maxDateTime: maxDateTime ?? DateTime.now(),
                  datePickerType: datePickerType,
                )
              ],
            )
          ],
        );
      });
}

// ignore: must_be_immutable
class _DatePickerView extends StatefulWidget {
  DateTime? startDateTime;
  DateTime? endDateTime;
  DateTime minDateTime;
  DateTime maxDateTime;
  DatePickerType datePickerType;

  _DatePickerView({
    required this.minDateTime, required this.maxDateTime, required this.datePickerType, Key? key,
    this.startDateTime,
    this.endDateTime,
  }) : super(key: key);

  @override
  __DatePickerViewState createState() => __DatePickerViewState();
}

class __DatePickerViewState extends State<_DatePickerView> {
  DatePickerChooseType _currentChoose = DatePickerChooseType.startDateTime;
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  GlobalKey<_PickViewState> startPickerKey = GlobalKey<_PickViewState>();
  GlobalKey<_PickViewState> endPickerKey = GlobalKey<_PickViewState>();

  bool get _confirmBtnEnabled => _startDateTime != null && _endDateTime != null;

  @override
  void initState() {
    _startDateTime = widget.startDateTime ?? DateTime.now();
    _endDateTime = widget.endDateTime;
    super.initState();
  }

  String _startTimeText() {
    return _formatDateTime(_startDateTime!);
  }

  String _endTimeText() {
    return _endDateTime == null ? '结束日期' : _formatDateTime(_endDateTime!);
  }

  String _formatDateTime(DateTime dateTime) {
    String data =
        '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}';
    if (widget.datePickerType == DatePickerType.Y_M_D) {
      data += '-${dateTime.day.toString().padLeft(2, '0')}';
    }

    return data;
  }

  void _changeDateTime(DatePickerChooseType type) {
    if (type == _currentChoose) return;
    setState(() {
      if (type == DatePickerChooseType.endDateTime && _endDateTime == null) {
        _endDateTime = DateTime.now();
      }
      _currentChoose = type;

      if (type == DatePickerChooseType.startDateTime) {
        startPickerKey.currentState?.fixPos();
      } else {
        endPickerKey.currentState?.fixPos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildTimeView(),
        _buildPickerView(),
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 60,
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '日期选择',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF3C3C3C),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.all(0),
            icon: const Icon(
              Icons.close,
              color: Color(0xFF9E9E9E),
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeView() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          _DateTimeView(
            text: _startTimeText(),
            isSelected: _currentChoose == DatePickerChooseType.startDateTime,
            onTap: () => _changeDateTime(DatePickerChooseType.startDateTime),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: const Text(
              '至',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF3C3C3C),
              ),
            ),
          ),
          _DateTimeView(
            text: _endTimeText(),
            isSelected: _currentChoose == DatePickerChooseType.endDateTime,
            onTap: () => _changeDateTime(DatePickerChooseType.endDateTime),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerView() {
    return SizedBox(
      height: 250,
      child: IndexedStack(
        index: _currentChoose == DatePickerChooseType.startDateTime ? 0 : 1,
        children: [
          _PickView(
            key: startPickerKey,
            dateTime: _startDateTime,
            minDateTime: widget.minDateTime,
            maxDateTime: _endDateTime ?? widget.maxDateTime,
            datePickerType: widget.datePickerType,
            onDateTimeChanged: (DateTime dateTime) {
              setState(() {
                _startDateTime = dateTime;
              });
            },
          ),
          _endDateTime == null
              ? const SizedBox()
              : _PickView(
                  key: endPickerKey,
                  dateTime: _endDateTime,
                  minDateTime: _startDateTime,
                  maxDateTime: widget.maxDateTime,
                  datePickerType: widget.datePickerType,
                  onDateTimeChanged: (DateTime dateTime) {
                    setState(() {
                      _endDateTime = dateTime;
                    });
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          backgroundColor: MaterialStateProperty.all(_confirmBtnEnabled
              ? const Color(0xFFF4272D)
              : const Color(0xFFD0D0D0)),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: _confirmBtnEnabled
            ? () {
                Navigator.pop(
                    context,
                    DatePickerResult(
                        startDateTime: _startDateTime,
                        endDatetime: _endDateTime));
              }
            : null,
        child: const Text(
          '确定',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
// ignore: must_be_immutable
class _PickView extends StatefulWidget {
  DateTime? dateTime;
  DateTime? minDateTime;
  DateTime maxDateTime;
  DatePickerType datePickerType;
  DateTimeChanged? onDateTimeChanged;

  _PickView({
    required this.minDateTime, required this.maxDateTime, Key? key,
    this.dateTime,
    this.onDateTimeChanged,
    this.datePickerType = DatePickerType.Y_M_D,
  }) : super(key: key);

  @override
  State<_PickView> createState() => _PickViewState();
}

class _PickViewState extends State<_PickView> {
  FixedExtentScrollController? _yearScrollController;
  FixedExtentScrollController? _monthScrollController;
  FixedExtentScrollController? _dayScrollController;

  late DateTime _dateTime;

  @override
  void initState() {
    _dateTime = widget.dateTime ?? DateTime.now();

    var minDateTime = widget.minDateTime;
    int yearPosition = minDateTime == null ? 0 : (_dateTime.year - minDateTime.year);
    _yearScrollController = FixedExtentScrollController(
        initialItem: yearPosition);
    _monthScrollController =
        FixedExtentScrollController(initialItem: _initMonthPos());
    _dayScrollController =
        FixedExtentScrollController(initialItem: _initDayPos());

    super.initState();
  }

  void fixPos() {
    setState(() {});
    _monthScrollController!.jumpToItem(_initMonthPos());
    _dayScrollController!.jumpToItem(_initDayPos());
  }

  int _initMonthPos() {
    if (_dateTime.year == widget.minDateTime!.year) {
      return _dateTime.month - widget.minDateTime!.month;
    }
    return _dateTime.month - 1;
  }

  int _initDayPos() {
    if (_dateTime.year == widget.minDateTime!.year &&
        _dateTime.month == widget.minDateTime!.month) {
      return _dateTime.day - widget.minDateTime!.day;
    }
    return _dateTime.day - 1;
  }

  int _yearCount() {
    return widget.maxDateTime.year - widget.minDateTime!.year + 1;
  }

  int _monthCount() {
    final year = _year();
    final maxDateTime = widget.maxDateTime;
    final minDateTime = widget.minDateTime;
    if (year == maxDateTime.year && minDateTime!.year == maxDateTime.year) {
      return maxDateTime.month - minDateTime.month + 1;
    } else if (year == maxDateTime.year) {
      return maxDateTime.month;
    } else if (year == minDateTime!.year) {
      return 12 - minDateTime.month;
    } else {
      return 12;
    }
  }

  int _lastDayInMonth(DateTime dateTime) {
    final days = [
      31,
      dateTime.year % 4 == 0 ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return days[dateTime.month - 1];
  }

  int _dayCount() {
    final days = [
      31,
      _year() % 4 == 0 ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    int day = days[_month() - 1];

    final year = _year();
    final month = _month();
    final maxDateTime = widget.maxDateTime;
    final minDateTime = widget.minDateTime!;

    if (year == maxDateTime.year && month == maxDateTime.month) {
      day = maxDateTime.day;
    }

    if (year == minDateTime.year && month == minDateTime.month) {
      day = day - minDateTime.day + 1;
    }

    return day;
  }

  int _year() {
    if (_yearScrollController!.positions.isEmpty) {
      return _dateTime.year;
    }
    return widget.minDateTime!.year + _yearScrollController!.selectedItem;
  }

  int _month() {
    try {
      if (_monthScrollController!.positions.isEmpty) {
        return _dateTime.month;
      }
      return _minMonth() + _monthScrollController!.selectedItem;
    } catch (e, _) {
      return _dateTime.month;
    }
  }

  int _minMonth() {
    final year = _year();
    final minDateTime = widget.minDateTime!;
    if (year == minDateTime.year) {
      return minDateTime.month;
    } else {
      return 1;
    }
  }

  int _day() {
    if (_dayScrollController!.positions.isEmpty) {
      return _dateTime.day;
    }
    return min(_minDay() + _dayScrollController!.selectedItem,
        _lastDayInMonth(DateTime(_year(), _month())));
  }

  int _minDay({DateTime? dateTime}) {
    final year = dateTime?.year ?? _year();
    final month = dateTime?.month ?? _month();
    final minDateTime = widget.minDateTime!;
    if (year == minDateTime.year && month == minDateTime.month) {
      return minDateTime.day;
    }
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final yearCount = _yearCount();
    final monthCount = _monthCount();
    final dayCount = _dayCount();

    final dayWidget = ListWheelScrollView.useDelegate(
      itemExtent: 50,
      perspective: 0.0001,
      controller: _dayScrollController,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildBuilderDelegate(
        builder: (context, index) {
          final day = _minDay() + index;
          final isSelected = day == _dateTime.day;
          final opacity = (day - _dateTime.day).abs() > 1 ? 0.2 : 0.6;
          return Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: isSelected ? 18 : 16,
                color: isSelected
                    ? const Color(0xFF3C3C3C)
                    : const Color(0xFF3C3C3C).withOpacity(opacity),
              ),
            ),
          );
        },
        childCount: dayCount,
      ),
    );

    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Stack(
        alignment: Alignment.center,
        children: [
          NotificationListener<ScrollEndNotification>(
            onNotification: (_) {
              if (widget.onDateTimeChanged != null) {
                final year = _year();
                final month = _month();
                final day = _day();
                _dateTime = DateTime(year, month, day);
                widget.onDateTimeChanged?.call(_dateTime);

                Future.delayed(const Duration(milliseconds: 300), () {
                  if (_monthScrollController!.selectedItem >= _monthCount()) {
                    _monthScrollController!.jumpToItem(_monthCount() - 1);
                  }

                  if (_dayScrollController!.selectedItem >= _dayCount()) {
                    _dayScrollController!.jumpToItem(_dayCount() - 1);
                  }
                });
              }
              return true;
            },
            child: Row(
              children: [
                Expanded(
                    child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  perspective: 0.0001,
                  controller: _yearScrollController,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final year = widget.minDateTime!.year + index;
                      final isSelected = year == _dateTime.year;
                      final opacity =
                          (year - _dateTime.year).abs() > 1 ? 0.2 : 0.6;
                      return Center(
                        child: Text(
                          '$year',
                          style: TextStyle(
                            fontSize: isSelected ? 18 : 16,
                            color: isSelected
                                ? const Color(0xFF3C3C3C)
                                : const Color(0xFF3C3C3C).withOpacity(opacity),
                          ),
                        ),
                      );
                    },
                    childCount: yearCount,
                  ),
                )),
                Expanded(
                    child: ListWheelScrollView.useDelegate(
                  itemExtent: 50,
                  perspective: 0.0001,
                  controller: _monthScrollController,
                  physics: const FixedExtentScrollPhysics(),
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final month = _minMonth() + index;
                      final isSelected = month == _dateTime.month;
                      final opacity =
                          (month - _dateTime.month).abs() > 1 ? 0.2 : 0.6;
                      return Center(
                        child: Text(
                          '$month',
                          style: TextStyle(
                            fontSize: isSelected ? 18 : 16,
                            color: isSelected
                                ? const Color(0xFF3C3C3C)
                                : const Color(0xFF3C3C3C).withOpacity(opacity),
                          ),
                        ),
                      );
                    },
                    childCount: monthCount,
                  ),
                )),
                widget.datePickerType == DatePickerType.Y_M_D
                    ? Expanded(child: dayWidget)
                    : SizedBox(
                        width: 0,
                        child: dayWidget,
                      ),
              ],
            ),
          ),
          IgnorePointer(
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE1E1E1)),
                  bottom: BorderSide(color: Color(0xFFE1E1E1)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _yearScrollController!.dispose();
    _monthScrollController!.dispose();
    _dayScrollController!.dispose();
    super.dispose();
  }
}

// ignore: must_be_immutable
class _DateTimeView extends StatelessWidget {
  String text;
  bool isSelected;
  GestureTapCallback? onTap;

  _DateTimeView({
    required this.text, Key? key,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7.5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color(isSelected ? 0xFFE60012 : 0xFFE1E1E1),
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Color(isSelected ? 0xFF3C3C3C : 0xFFB7B7B7),
            ),
          ),
        ),
      ),
    );
  }
}

typedef DateTimeChanged = void Function(DateTime);

enum DatePickerChooseType {
  startDateTime,
  endDateTime,
}

enum DatePickerType {
  // ignore: constant_identifier_names
  Y_M,
  // ignore: constant_identifier_names
  Y_M_D,
}

class DatePickerResult {
  DateTime? startDateTime;
  DateTime? endDatetime;

  DatePickerResult({this.startDateTime, this.endDatetime});
}
