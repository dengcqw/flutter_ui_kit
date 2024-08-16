import 'package:flutter/material.dart';
import 'dart:core';
import 'package:fluttertoast/fluttertoast.dart';
import '../styles/var.dart';
import '../utils/widget.dart';
import 'button.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

int getMonthEndDay(int year, int month) {
  return 32 - DateTime(year, month, 32).day;
}

typedef FlanCalendarDayBuilder = Widget Function(FlanCalendarDayItem item);
typedef FlanCalendarDayItemFormatter = FlanCalendarDayItem Function(
    FlanCalendarDayItem item);

typedef FlanCalendarDayVoidCallback = void Function(FlanCalendarDayItem item);

DateTime _getDefaultMaxDate() {
  final DateTime now = getToday();
  return DateTime(now.year, now.month + 6, now.day);
}

/// ### FlanCalendar 日历
/// 日历组件用于选择日期或日期区间。
class FlanCalendar extends StatefulWidget {
  FlanCalendar({
    Key? key,
    this.title = '',
    this.showExit = false,
    this.subTitle = '',
    this.color,
    this.readonly = false,
    this.showMark = true,
    this.showTitle = true,
    this.formatter,
    this.rowHeight,
    this.confirmText = '',
    this.rangePrompt = '',
    this.showConfirm = true,
    this.defaultDate = const <DateTime>[],
    this.showSubtitle = true,
    this.allowSameDay = false,
    this.confirmDisabledText = '',
    this.maxRange = 0,
    DateTime? minDate,
    DateTime? maxDate,
    this.firstDayOfWeek = 7,
    this.showRangePrompt = true,
    this.type = FlanCalendarType.single,
    this.safeAreaInsetBottom = false,
    this.onSelect,
    this.onConfirm,
    this.onUnSelect,
    this.onOverRange,
    this.onMonthShow,
    this.titleSlot,
    this.footerSlot,
    this.topInfoBuilder,
    this.bottomInfoBuilder,
  })  : minDate = minDate ?? getToday(),
        maxDate = maxDate ?? _getDefaultMaxDate(),
        super(key: key);

  // ****************** Props ******************
  final String title;
  final String subTitle;
  final bool showExit;
  final Color? color;
  final bool readonly;
  final bool showMark;
  final bool showTitle;
  final FlanCalendarDayItemFormatter? formatter;
  final double? rowHeight;
  final String confirmText;
  final String rangePrompt;
  final bool showConfirm;
  final List<DateTime> defaultDate;
  final bool showSubtitle;
  final bool allowSameDay;
  final String confirmDisabledText;
  final int maxRange;
  final DateTime minDate;
  final DateTime maxDate;
  final int firstDayOfWeek;
  final bool showRangePrompt;
  final FlanCalendarType type;
  final bool safeAreaInsetBottom;

  // ****************** Events ******************
  final ValueChanged<List<DateTime>>? onSelect;
  final ValueChanged<List<DateTime>>? onConfirm;
  final ValueChanged<List<DateTime>>? onUnSelect;
  final ValueChanged<FlanCalendarMonthDetail>? onMonthShow;
  final VoidCallback? onOverRange;

  // ****************** Slots ******************
  final Widget? titleSlot;
  final Widget? footerSlot;
  final FlanCalendarDayBuilder? topInfoBuilder;
  final FlanCalendarDayBuilder? bottomInfoBuilder;

  static FlanCalendarState? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FlanCalendarScope>()
        ?.state;
  }

  @override
  FlanCalendarState createState() => FlanCalendarState();
}

class FlanCalendarState extends State<FlanCalendar> {
  String subtitle = '';
  late List<DateTime> months;
  late List<DateTime> currentDate;
  String Function(Object year, Object month) titleFormatter =
      (year, month) => "$year年$month月";

  List<double> monthHeights = <double>[];
  final ScrollController controller = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  @override
  void initState() {
    currentDate = getInitialDate();
    months = getMonths();
    monthHeights = List<double>.generate(months.length, (_) => 0.0);

    super.initState();
  }



  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCalendar();
  }

  void registerMonth(FlanCalendarMonthState monthState, int index) {
    final double height = monthState.context.size?.height ?? 0.0;

    if (index < monthHeights.length) {
      monthHeights[index] = height;
      widget.onMonthShow?.call(FlanCalendarMonthDetail(
        date: monthState.widget.date,
        title: monthState.title,
      ));
    } else {
      // monthHeights.add(height);
    }
  }

  void unRegisterMonth(BuildContext context, int index) {
    if (index >= 0 && index < monthHeights.length) {
      monthHeights.removeAt(index);
    }
  }

  DateTime limitDateRange(
      DateTime date, [
        DateTime? minDate,
        DateTime? maxDate,
      ]) {
    minDate ??= widget.minDate;
    maxDate ??= widget.maxDate;
    if (compareDay(date, minDate) == -1) {
      return minDate;
    }
    if (compareDay(date, maxDate) == 1) {
      return maxDate;
    }
    return date;
  }

  List<DateTime> getInitialDate([List<DateTime>? defaultDate]) {
    defaultDate ??= widget.defaultDate;
    if (defaultDate.isEmpty) {
      return defaultDate;
    }

    final DateTime now = getToday();
    if (widget.type == FlanCalendarType.range) {
      final DateTime start = limitDateRange(
        defaultDate.isNotEmpty ? defaultDate[0] : now,
        widget.minDate,
        widget.allowSameDay ? widget.maxDate : getPreDay(widget.maxDate),
      );
      final DateTime end = limitDateRange(
        defaultDate.length > 1 ? defaultDate[1] : now,
          widget.allowSameDay ? widget.minDate : getNextDay(widget.minDate),
      );
      return <DateTime>[start, end];
    }

    // if (widget.type == FlanCalendarType.multiple) {
    return defaultDate.map((DateTime date) => limitDateRange(date)).toList();
    // }
  }

  int get dayOffset =>
      widget.firstDayOfWeek != 0 ? widget.firstDayOfWeek % 7 : 0;

  List<DateTime> getMonths() {
    final List<DateTime> months = <DateTime>[];
    DateTime cursor = DateTime(widget.minDate.year, widget.minDate.month, 1);

    do {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1, 1);
    } while (compareMonth(cursor, widget.maxDate) != 1);

    return months;
  }

  bool get buttonDisabled {
    if (currentDate.isNotEmpty) {
      if (widget.type == FlanCalendarType.range) {
        return currentDate.length != 2;
      }
      if (widget.type == FlanCalendarType.multiple) {
        return currentDate.isEmpty;
      }
    }

    return currentDate.isEmpty;
  }

  void reset(List<DateTime>? date) {
    date ??= getInitialDate();
    currentDate = date;
  }

  bool checkRange(List<DateTime> date) {
    if (widget.maxRange != 0 && calcDateNum(date) > widget.maxRange) {
      if (widget.showRangePrompt) {
        Fluttertoast.showToast(
            msg: widget.rangePrompt.isNotEmpty
                ? widget.rangePrompt
                : "选择天数不能超过 ${widget.maxRange} 天",
            gravity: ToastGravity.CENTER);
        widget.onOverRange?.call();
        return false;
      }
    }
    return true;
  }

  void onConfirm() => widget.onConfirm?.call(cloneDates(currentDate));

  void select(List<DateTime> date, [bool complete = false]) {
    void setCurrentDate(List<DateTime> date) {
      currentDate = date;
      widget.onSelect?.call(cloneDates(currentDate));
      setState(() {});
    }

    if (complete && widget.type == FlanCalendarType.range) {
      final bool valid = checkRange(date);
      if (!valid) {
        if (widget.showConfirm) {
          setCurrentDate(<DateTime>[
            date[0],
            getDayByOffset(date[0], widget.maxRange - 1),
          ]);
        } else {
          setCurrentDate(date);
        }
        return;
      }
    }
    setCurrentDate(date);
    if (complete && !widget.showConfirm) {
      onConfirm();
    }
  }

  void onClickDay(FlanCalendarDayItem item) {
    if (widget.readonly || item.date == null) {
      return;
    }

    final DateTime date = item.date!;
    if (widget.type == FlanCalendarType.range) {
      if (currentDate.isEmpty) {
        select(<DateTime>[date]);
        return;
      }

      if (currentDate.length == 1) {
        final DateTime startDay = currentDate[0];
        final int compareToStart = compareDay(date, startDay);

        if (compareToStart == 1) {
          select(<DateTime>[startDay, date], true);
        } else if (compareToStart == -1) {
          select(<DateTime>[date]);
        } else if (widget.allowSameDay) {
          select(<DateTime>[date, date], true);
        }
      } else {
        select(<DateTime>[date]);
      }
    } else if (widget.type == FlanCalendarType.multiple) {
      // if (currentDate.isEmpty) {
      //   select(<DateTime>[date]);
      //   return;
      // }

      int selectedIndex = 0;
      bool selected = false;

      for (int i = 0; i < currentDate.length; i++) {
        final DateTime dateItem = currentDate[i];
        final bool equal = compareDay(dateItem, date) == 0;
        if (equal) {
          selectedIndex = i;
          selected = true;
        }
      }
      if (selected) {
        final List<DateTime> unselectedDate = <DateTime>[
          currentDate.removeAt(selectedIndex)
        ];
        widget.onUnSelect?.call(cloneDates(unselectedDate));
        setState(() {});
      } else if (widget.maxRange != 0 &&
          currentDate.length >= widget.maxRange) {
        Fluttertoast.showToast(
            msg: widget.rangePrompt.isNotEmpty
                ? widget.rangePrompt
                : "选择天数不能超过 ${widget.maxRange} 天",
            gravity: ToastGravity.CENTER);
      } else {
        select(<DateTime>[...currentDate, date]);
      }
    } else {
      select(<DateTime>[date], true);
    }
  }

  Widget _buildMonth(DateTime date, int index) {
    final bool showMonthTitle = index != 0 || !widget.showSubtitle;
    return FlanCalendarMonth(
      index: index,
      topInfoBuilder: widget.topInfoBuilder,
      bottomInfoBuilder: widget.bottomInfoBuilder,
      date: date,
      currentDate: currentDate,
      showMonthTitle: showMonthTitle,
      firstDayOfWeek: 7,  //7表示以周日为每周的第一天
      maxDate: widget.maxDate,
      minDate: widget.minDate,
      type: widget.type,
      color: widget.color,
      showMark: widget.showMark,
      formatter: widget.formatter,
      rowHeight: widget.rowHeight,
      showSubtitle: widget.showSubtitle,
      allowSameDay: widget.allowSameDay,
      onClick: onClickDay,
    );
  }

  Widget _buildFooterButton() {
    if (widget.footerSlot != null) {
      return widget.footerSlot!;
    }
    final String text =
    buttonDisabled ? widget.confirmDisabledText : widget.confirmText;
    return GestureDetector(
        onTap: onConfirm,
        child: Container(
        height: 67,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: buttonDisabled  ? ThemeVars.calendarDayDisabledColor : ThemeVars.calendarSelectedDayBackgroundColor,
            borderRadius:  BorderRadius.circular(67 / 2.0)
        ),
        child: Text(text.isNotEmpty ? text : '确认',style: const TextStyle(color: ThemeVars.calendarSelectedDayColor,fontSize: ThemeVars.fontSizeLg),),
      ),
    );
  }

  Widget _buildFooter() {
    return SafeArea(
      bottom: widget.safeAreaInsetBottom,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          width: 226,
          height: ThemeVars.calendarConfirmButtonHeight + 6,
          child: _buildFooterButton(),
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return Column(
      children: <Widget>[
        FlanCalendarHeader(
          titleSlot: widget.titleSlot,
          title: widget.title,
          showTitle: widget.showTitle,
          subTitle: widget.subTitle,
          showExit: widget.showExit,
          showSubTitles: widget.showSubtitle,
          firstDayOfWeek: dayOffset,
        ),
        Expanded(
            child: FlanCalendarScope(
            state: this,
            child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
        child: ScrollablePositionedList.builder(
          itemCount: months.length,
          itemBuilder: (context, index) =>
              _buildMonth(months[index], index),
          itemScrollController: itemScrollController,
          initialScrollIndex: months.length - 1,
          itemPositionsListener: itemPositionsListener,
        ),
    )
            )
        ),
        _buildFooter(),
      ],
    );
  }
}

class FlanCalendarScope extends InheritedWidget {
  const FlanCalendarScope({
    required this.state, required Widget child, Key? key,
  }) : super(key: key, child: child);

  final FlanCalendarState state;

  // ignore: unused_element
  static FlanCalendarScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FlanCalendarScope>();
  }

  @override
  bool updateShouldNotify(FlanCalendarScope oldWidget) {
    return state != oldWidget.state;
  }
}

class FlanCalendarMonth extends StatefulWidget {
  const FlanCalendarMonth({
    required this.type, required this.index, required this.firstDayOfWeek, required this.date, required this.minDate, required this.maxDate, Key? key,
    this.color,
    this.showMark = false,
    this.rowHeight,
    this.formatter,
    this.currentDate = const <DateTime>[],
    this.allowSameDay = false,
    this.showSubtitle = false,
    this.showMonthTitle = false,
    this.onClick,
    this.onUpdateHeight,
    this.topInfoBuilder,
    this.bottomInfoBuilder,
  }) : super(key: key);

  // ****************** Props ******************
  final FlanCalendarType type;
  final int index;
  final Color? color;
  final bool showMark;
  final double? rowHeight;
  final FlanCalendarDayItemFormatter? formatter;
  final List<DateTime> currentDate;
  final bool allowSameDay;
  final bool showSubtitle;
  final bool showMonthTitle;
  final int firstDayOfWeek;
  final DateTime date;
  final DateTime minDate;
  final DateTime maxDate;

  // ****************** Events ******************
  final FlanCalendarDayVoidCallback? onClick;
  final VoidCallback? onUpdateHeight;

  // ****************** Slots ******************
  final FlanCalendarDayBuilder? topInfoBuilder;
  final FlanCalendarDayBuilder? bottomInfoBuilder;

  @override
  FlanCalendarMonthState createState() => FlanCalendarMonthState();
}

class FlanCalendarMonthState extends State<FlanCalendarMonth> {
  @override
  void initState() {
    syncMonth();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FlanCalendarMonth oldWidget) {
    syncMonth();
    super.didUpdateWidget(oldWidget);
  }

  void syncMonth() {
    nextTick(() {
      if(mounted){
        FlanCalendar.of(context)?.registerMonth(this, widget.index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTitle(),
        _buildDays(),
      ],
    );
  }

  String get title => "${widget.date.year}年${widget.date.month}月";

  FlanCalendarDayType getMultipleDayType(DateTime day) {
    bool isSelected(DateTime date) =>
        widget.currentDate.any((DateTime item) => compareDay(item, date) == 0);

    if (isSelected(day)) {
      final DateTime preDay = getPreDay(day);
      final DateTime nextDay = getNextDay(day);
      final bool prevSelected = isSelected(preDay);
      final bool nextSelected = isSelected(nextDay);

      if (prevSelected && nextSelected) {
        return FlanCalendarDayType.multipleMiddle;
      }

      if (prevSelected) {
        return FlanCalendarDayType.end;
      }

      if (nextSelected) {
        return FlanCalendarDayType.start;
      }

      return FlanCalendarDayType.multipleSelected;
    }

    return FlanCalendarDayType.normal;
  }

  FlanCalendarDayType getRangeDayType(DateTime day) {
    if (widget.currentDate.isEmpty) {
      return FlanCalendarDayType.normal;
    }

    final DateTime startDay = widget.currentDate[0];
    final int compareToStart = compareDay(day, startDay);

    if (widget.currentDate.length < 2) {
      return compareToStart == 0
          ? FlanCalendarDayType.start
          : FlanCalendarDayType.normal;
    }

    final DateTime endDay = widget.currentDate[1];
    final int compareToEnd = compareDay(day, endDay);
    if (widget.allowSameDay && compareToStart == 0 && compareToEnd == 0) {
      return FlanCalendarDayType.startEnd;
    }

    if (compareToStart == 0) {
      return FlanCalendarDayType.start;
    }

    if (compareToEnd == 0) {
      return FlanCalendarDayType.end;
    }
    if (compareToStart > 0 && compareToEnd < 0) {
      return FlanCalendarDayType.middle;
    }

    return FlanCalendarDayType.normal;
  }

  FlanCalendarDayType getDayType(DateTime day) {
    if (compareDay(day, widget.minDate) < 0 ||
        compareDay(day, widget.maxDate) > 0) {
      return FlanCalendarDayType.disabled;
    }

    if (widget.currentDate.isEmpty) {
      return FlanCalendarDayType.normal;
    }

    if (widget.currentDate.isNotEmpty) {
      if (widget.type == FlanCalendarType.multiple) {
        return getMultipleDayType(day);
      }
      if (widget.type == FlanCalendarType.range) {
        return getRangeDayType(day);
      }
      if (widget.type == FlanCalendarType.single) {
        return compareDay(day, widget.currentDate[0]) == 0
            ? FlanCalendarDayType.selected
            : FlanCalendarDayType.normal;
      }
    }

    return FlanCalendarDayType.normal;
  }

  String getTopInfo(FlanCalendarDayType dayType,DateTime date) {
    if (compareDay(date, DateTime.now()) == 0) return '今天';
    return '';
  }

  String getBottomInfo(FlanCalendarDayType dayType) {
    if (widget.type == FlanCalendarType.range) {
      if (dayType == FlanCalendarDayType.start) {
        return '开始';
      }
      if (dayType == FlanCalendarDayType.end) {
        return '结束';
      }
      if (dayType == FlanCalendarDayType.startEnd) {
        return "开始/结束";
      }
    }
    return '';
  }

  void scrollIntoView() {
    Scrollable.ensureVisible(context);
  }

  Widget _buildTitle() {
    return Visibility(
      visible: widget.showMonthTitle,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: ThemeVars.calendarMonthTitleFontSize,
          height: ThemeVars.calendarHeaderTitleHeight /
              ThemeVars.calendarMonthTitleFontSize,
          fontWeight: ThemeVars.fontWeightBold,
        ),
        textAlign: TextAlign.center,
        textHeightBehavior: FlanThemeVars.textHeightBehavior,
      ),
    );
  }

  Widget _buildMark() {
    return Visibility(
      visible: widget.showMark,
      child: Text(
        '${widget.date.month}',
        style: TextStyle(
          fontSize: ThemeVars.calendarMonthMarkFontSize,
          color: ThemeVars.calendarMonthMarkColor,
        ),
        textAlign: TextAlign.center,
        textHeightBehavior: FlanThemeVars.textHeightBehavior,
      ),
    );
  }

  int get offset {
    final int realDay = widget.date.weekday;
    if (widget.firstDayOfWeek != 0) {
      return (realDay + 7 - widget.firstDayOfWeek) % 7;
    }
    return realDay;
  }

  int get totalDay => getMonthEndDay(widget.date.year, widget.date.month);

  List<FlanCalendarDayItem> get placeholders {
    final int count = (totalDay + offset) ~/ 7;
    return List<FlanCalendarDayItem>.generate(count, (_) {
      return FlanCalendarDayItem(type: FlanCalendarDayType.placeholder);
    });
  }

  List<FlanCalendarDayItem> get days {
    final List<FlanCalendarDayItem> days = <FlanCalendarDayItem>[];
    final int year = widget.date.year;
    final int month = widget.date.month;

    for (int day = 1; day <= totalDay; day++) {
      final DateTime date = DateTime(year, month, day);
      final FlanCalendarDayType type = getDayType(date);
      FlanCalendarDayItem config = FlanCalendarDayItem(
        date: date,
        type: type,
        text: '$day',
        bottomInfo: getBottomInfo(type),
        topInfo: getTopInfo(type,date),
      );
      if (widget.formatter != null) {
        config = widget.formatter!(config);
      }
      days.add(config);
    }
    return days;
  }

  Widget _buildDays() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _buildMark(),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Wrap(
              runSpacing: 4,
              children: List<Widget>.generate(days.length, (int index) {
                final double width =
                    (constraints.maxWidth / 7 * 10.0).floor() / 10.0;

                return FlanCalendarDay(
                  topInfoBuilder: widget.topInfoBuilder,
                  bottomInfoBuilder: widget.bottomInfoBuilder,
                  item: days[index],
                  index: index,
                  color: widget.color,
                  offset: offset,
                  rowWidth: width,
                  rowHeight: widget.rowHeight,
                  onClick: widget.onClick,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class FlanCalendarHeader extends StatelessWidget {
  const FlanCalendarHeader({
    Key? key,
    this.title = '',
    this.showExit = false,
    this.subTitle = '',
    this.showTitle = false,
    this.showSubTitles = false,
    this.firstDayOfWeek = 0,
    this.titleSlot,
  }) : super(key: key);

  // ****************** Props ******************
  final String title;
  final String subTitle;
  final bool showTitle;
  final bool showSubTitles;
  final int firstDayOfWeek;
  final bool showExit;
  // ****************** Events ******************

  // ****************** Slots ******************
  final Widget? titleSlot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTitle(context),
              _buildSubTitle(context),
              _buildWeekDays(context),
            ],
          ),
          Positioned(
              right: 0,
              top: 0,
              child: FlanButton(
                color: Colors.white,
                type: FlanButtonType.danger,
                onClick: () => Navigator.pop(context,),
                child: const Icon(
                  IconData(
                    0xe756,
                    fontFamily: 'myIcon',
                    fontPackage: 'ui_kit',
                  ),
                  size: 12,
                  color: Color(0xFFB7B7B7),
                ),
              )
          )

        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final String title = this.title.isNotEmpty ? this.title : "日期选择";
    return Visibility(
      visible: showTitle,
      child: Container(
        height: FlanThemeVars.calendarHeaderTitleHeight,
        alignment: Alignment.center,
        child: DefaultTextHeightBehavior(
          textHeightBehavior: FlanThemeVars.textHeightBehavior,
          child: DefaultTextStyle.merge(
            style: const TextStyle(
                inherit: false,
                fontSize: ThemeVars.calendarHeaderTitleFontSize,
                fontWeight: ThemeVars.fontWeightBold,
                color: Color(0xFF21171B),
                fontFamily: ThemeVars.priceIntegerFontFamily
              // height: FlanThemeVars.calendarHeaderTitleHeight,
            ),

            child: titleSlot ?? Text(title),
          ),
        ),
      ),
    );
  }

  Widget _buildSubTitle(BuildContext context) {
    return Visibility(
      visible: showSubTitles,
      child: Container(
        height: FlanThemeVars.calendarHeaderTitleHeight,
        alignment: Alignment.center,
        child: Text(
          subTitle,
          style: const TextStyle(
            fontSize: ThemeVars.calendarHeaderSubtitleFontSize,
            fontWeight: ThemeVars.fontWeightBold,
            // height: FlanThemeVars.calendarHeaderTitleHeight,
          ),
          textHeightBehavior: FlanThemeVars.textHeightBehavior,
        ),
      ),
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    final List<String> weekdays = <String>[
      "日",
      "一",
      "二",
      "三",
      "四",
      "五",
      "六",
    ];

    final List<String> renderWeekdays = <String>[
      ...weekdays.sublist(firstDayOfWeek, 7),
      ...weekdays.sublist(0, firstDayOfWeek),
    ];

    return Row(
      children: renderWeekdays.map((String day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                color: Color(0xFF61666D),
                fontSize: ThemeVars.calendarWeekdaysFontSize,
                height: ThemeVars.calendarWeekdaysHeight /
                    ThemeVars.calendarWeekdaysFontSize,
              ),
              textHeightBehavior: FlanThemeVars.textHeightBehavior,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class FlanCalendarDay extends StatelessWidget {
  const FlanCalendarDay({
    required this.rowWidth, required this.item, Key? key,
    this.color,
    this.index,
    this.rowHeight,
    this.offset = 0,
    this.onClick,
    this.topInfoBuilder,
    this.bottomInfoBuilder,
  }) : super(key: key);

  // ****************** Props ******************
  final Color? color;
  final int? index;
  final double? rowHeight;
  final double rowWidth;
  final int offset;
  final FlanCalendarDayItem item;

  // ****************** Events ******************
  final FlanCalendarDayVoidCallback? onClick;

  // ****************** Slots ******************
  final FlanCalendarDayBuilder? topInfoBuilder;

  final FlanCalendarDayBuilder? bottomInfoBuilder;

  @override
  Widget build(BuildContext context) {
    final bool isSmallSize = MediaQuery.of(context).size.width <= 350.0;

    final double selectedSize = rowHeight ?? ThemeVars.calendarSelectedDaySize;

    final Widget dayItem = MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onTap: _onClick,
        behavior: HitTestBehavior.opaque,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: textColor, fontSize: ThemeVars.fontSizeLg
          ),
          textAlign: TextAlign.center,
          child: Container(
            width: rowWidth,
            height: ThemeVars.calendarDayHeight,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Visibility(
                  visible: isSelected,
                  child: Container(
                    width: selectedSize,
                    height: selectedSize,
                    decoration: BoxDecoration(
                      color: ThemeVars.calendarSelectedDayBackgroundColor,
                      borderRadius:
                      BorderRadius.circular(ThemeVars.borderRadiusMd),
                    ),
                  ),
                ),
                Text(item.text),
                _buildTopInfo(isSmallSize),
                _buildBottomInfo(isSmallSize),
              ],
            ),
          ),
        ),
      ),
    );

    if (index == 0) {
      return Padding(
        padding: EdgeInsets.only(left: rowWidth * offset),
        child: dayItem,
      );
    }

    return dayItem;
  }

  Widget _buildTopInfo(bool isSmallSize) {
    if (item.topInfo.isNotEmpty || topInfoBuilder != null) {
      final fontSize = isSmallSize ? 9.0.rpx : ThemeVars.calendarInfoFontSize;
      return Positioned(
          top: (ThemeVars.calendarDayHeight / 2.0 - fontSize - 10.0 ).rpx,
          right: 0.0,
          left: 0.0,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: fontSize,
              // height: ThemeVars.calendarInfoLineHeight,
            ),
            textAlign: TextAlign.center,
            child: topInfoBuilder?.call(item) ?? Text(item.topInfo),
          ));
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomInfo(bool isSmallSize) {
    if (item.bottomInfo.isNotEmpty || bottomInfoBuilder != null) {
      final fontSize = isSmallSize ? 9.0.rpx : ThemeVars.calendarInfoFontSize;
      return Positioned(
          bottom: (ThemeVars.calendarDayHeight / 2 - fontSize - 10 ).rpx,
          right: 0.0,
          left: 0.0,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              fontSize: fontSize,
              // height: ThemeVars.calendarInfoLineHeight,
            ),
            textAlign: TextAlign.center,
            child: bottomInfoBuilder?.call(item) ?? Text(item.bottomInfo),
          ));
    }
    return const SizedBox.shrink();
  }

  BorderRadius? get borderRadius {
    switch (item.type) {
      case FlanCalendarDayType.start:
        return const BorderRadius.only(
          topLeft: Radius.circular(ThemeVars.borderRadiusMd),
          bottomLeft: Radius.circular(ThemeVars.borderRadiusMd),
        );
      case FlanCalendarDayType.end:
        return const BorderRadius.only(
          topRight: Radius.circular(ThemeVars.borderRadiusMd),
          bottomRight: Radius.circular(ThemeVars.borderRadiusMd),
        );
      case FlanCalendarDayType.startEnd:
      case FlanCalendarDayType.multipleSelected:
        return BorderRadius.circular(ThemeVars.borderRadiusMd);
      case FlanCalendarDayType.multipleMiddle:
      case FlanCalendarDayType.middle:
      case FlanCalendarDayType.selected:
      case FlanCalendarDayType.disabled:
      case FlanCalendarDayType.placeholder:
      case FlanCalendarDayType.normal:
        break;
    }
    return null;
  }

  Color? get backgroundColor {
    switch (item.type) {
      case FlanCalendarDayType.end:
      case FlanCalendarDayType.start:
      case FlanCalendarDayType.startEnd:
      case FlanCalendarDayType.multipleMiddle:
      case FlanCalendarDayType.multipleSelected:
        return color ?? ThemeVars.calendarRangeEdgeBackgroundColor;

      case FlanCalendarDayType.middle:
        return ThemeVars.calendarRangeMiddleColor
            .withOpacity(ThemeVars.calendarRangeMiddleBackgroundOpacity);
      case FlanCalendarDayType.selected:
        break;
    // return ThemeVars.calendarSelectedDayBackgroundColor;
      case FlanCalendarDayType.disabled:
        break;
      case FlanCalendarDayType.placeholder:
        break;
      case FlanCalendarDayType.normal:
        break;
    }
    return null;
  }

  Color? get textColor {
    switch (item.type) {
      case FlanCalendarDayType.end:
      case FlanCalendarDayType.start:
      case FlanCalendarDayType.startEnd:
      case FlanCalendarDayType.multipleMiddle:
      case FlanCalendarDayType.multipleSelected:
        return ThemeVars.calendarRangeEdgeColor;
      case FlanCalendarDayType.selected:
        return ThemeVars.calendarSelectedDayColor;

      case FlanCalendarDayType.disabled:
        return ThemeVars.calendarDayDisabledColor;
      case FlanCalendarDayType.placeholder:
        break;
      case FlanCalendarDayType.normal:
      case FlanCalendarDayType.middle:
        break;
    }
    return null;
  }

  bool get isSelected => item.type == FlanCalendarDayType.selected;

  MouseCursor get cursor {
    switch (item.type) {
      case FlanCalendarDayType.disabled:
        return SystemMouseCursors.basic;
      default:
        return SystemMouseCursors.click;
    }
  }

  void _onClick() {
    if (item.type != FlanCalendarDayType.disabled) {
      onClick?.call(item);
    }
  }
}

class FlanCalendarDayItem {
  FlanCalendarDayItem({
    this.date,
    this.text = '',
    this.type = FlanCalendarDayType.normal,
    this.topInfo = '',
    this.bottomInfo = '',
  });

  final DateTime? date;
  final String text;
  final FlanCalendarDayType type;
  final String topInfo;
  final String bottomInfo;
}

enum FlanCalendarType {
  single,
  range,
  multiple,
}

enum FlanCalendarDayType {
  normal,
  start,
  startEnd,
  middle,
  end,
  selected,
  multipleMiddle,
  multipleSelected,
  disabled,
  placeholder
}

int compareMonth(DateTime date1, DateTime date2) {
  final int year1 = date1.year;
  final int year2 = date2.year;

  if (year1 == year2) {
    final int month1 = date1.month;
    final int month2 = date2.month;

    return month1 == month2
        ? 0
        : month1 > month2
        ? 1
        : -1;
  }
  return year1 > year2 ? 1 : -1;
}

int compareDay(DateTime day1, DateTime day2) {
  final int compareMonthResult = compareMonth(day1, day2);
  if (compareMonthResult == 0) {
    final int date1 = day1.day;
    final int date2 = day2.day;
    return date1 == date2
        ? 0
        : date1 > date2
        ? 1
        : -1;
  }

  return compareMonthResult;
}

DateTime cloneDate(DateTime date) =>
    DateTime.fromMillisecondsSinceEpoch(date.millisecondsSinceEpoch);

List<DateTime> cloneDates(List<DateTime> dates) =>
    dates.map(cloneDate).toList();

DateTime getDayByOffset(DateTime date, int offset) {
  if (offset.sign < 0) {
    return date.subtract(Duration(days: offset.abs()));
  }
  return date.add(Duration(days: offset));
}

DateTime getPreDay(DateTime date) => getDayByOffset(date, -1);
DateTime getNextDay(DateTime date) => getDayByOffset(date, 1);
DateTime getToday() {
  final DateTime now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

int calcDateNum(List<DateTime> date) {
  return date[1].difference(date[0]).inDays + 1;
}

class FlanCalendarMonthDetail {
  FlanCalendarMonthDetail({
    required this.date,
    required this.title,
  });
  final DateTime date;
  final String title;
}
