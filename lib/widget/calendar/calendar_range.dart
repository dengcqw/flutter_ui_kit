

import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:ui_kit/color_style.dart';
import 'package:ui_kit/utils/common.dart';
import 'package:ui_kit/widget/toast.dart';
import 'date_picker.dart';

/*
 * date：默认日期
 * callBack:选择回调
 * getObj: 返回json时间段对象的方法
 */
class CalendarRange extends StatefulWidget {
  const CalendarRange({
    Key? key,
    this.callBack,
    this.startTime,
    this.endTime,
    this.minDate, //可选最小日期
    this.maxDate, //可选最大日期
    this.maxRange = 365, //最大区间默认一年
    this.textSize = 14,
    this.separator = '-', //设置两个时间直接的分隔符 默认是"~"
    this.iconSpacing = 10, //设置时间和icon直接的间距,默认是10
  }) : super(key: key);
  final Function? callBack;
  final String? startTime;
  final String? endTime;
  final int maxRange;
  final String? minDate;
  final String? maxDate;
  final double textSize;
  final String separator;
  final double iconSpacing;

  @override
  State<StatefulWidget> createState() {
    return CalendarRanges();
  }
}

class CalendarRanges extends State<CalendarRange> {
  String time = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  Map times = {"startTime": "", "endTime": ""};

  @override
  void initState() {
    super.initState();
    debugPrint('startTime----${widget.startTime}---endTime----${widget.endTime}');
    times = {
      "startTime": widget.startTime ?? time,
      "endTime": widget.endTime ?? time
    };
  }

  @override
  void didUpdateWidget(covariant CalendarRange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.startTime != widget.startTime){
      times = {
        "startTime": widget.startTime ?? time,
        "endTime": widget.endTime ?? time
      };
      setState(() {

      });
    }
  }



  Future<void> showCalendar() async {
    var currentDateString = DateTime.now().toString().substring(0, 10);
    var minDefaultDate = Common.calcTime(currentDateString, -365);

    showRangeCalendar(
      context,
      startDateTime: DateTime.tryParse(times['startTime'] ?? time) ?? DateTime.now(),
      endDateTime: DateTime.tryParse(times['endTime'] ?? time) ?? DateTime.now(),
      minDateTime: DateTime.tryParse(widget.minDate ?? minDefaultDate ?? time) ?? DateTime.now(),
      maxRange: widget.maxRange,
      //日期选择器上可选择的最早日期
      maxDateTime:
          DateTime.tryParse(widget.maxDate ?? time) ?? DateTime.now(), //日期选择器上可选择的最晚日期
    ).then((result) {
      if (result == null) return;
      var start = (result.startDateTime ?? DateTime.now()).millisecondsSinceEpoch;
      var end = (result.endDatetime ?? DateTime.now()).millisecondsSinceEpoch;
      var long = end - start;
      if (long > 31536000000) {
        Toast.toast(context, '仅支持查看一年内的数据');
        return;
      }
      if (widget.maxRange>0&&long > widget.maxRange*86400000) {
        Toast.toast(context, '仅支持查看${widget.maxRange}天内的数据');
        return;
      }
      var time = {
        "startTime": formatDate(result.startDateTime?? DateTime.now(), [yyyy, '-', mm, '-', dd]),
        "endTime": formatDate(result.endDatetime?? DateTime.now(), [yyyy, '-', mm, '-', dd]),
      };
      saveDate(time);
    });
    // }
  }

  // 保存日期，调用回调函数
  void saveDate(data) async {
    debugPrint('saveDate---$data');
    if (data == null) return;
    setState(() {
      times = data;
    });
    widget.callBack!(data);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(minWidth: 138),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Image.asset('images/icon/icon_calendar_left.png', width: 18, height: 18,),
                ),
                onTap: () {
                  //开始时间和结束时间各减一天
                  String startTime = times['startTime'];
                  String endTime = times['endTime'];
                  DateTime s = DateTime.parse(startTime);
                  DateTime e = DateTime.parse(endTime);
                  s = s.add(const Duration(days: -1));
                  e = e.add(const Duration(days: -1));
                  startTime = s.toString().substring(0, 10);
                  endTime = e.toString().substring(0, 10);
                  debugPrint('s--$startTime -- e -- $endTime');
                  saveDate({"startTime": startTime, "endTime": endTime});
                },
              ),
              SizedBox(
                width: widget.iconSpacing,
              ),
              InkWell(
                child: Container(
                  alignment: Alignment.center,
                  height: 44,
                  child: Text(
                    '${times['startTime']} ~ ${times['endTime']}'
                        .replaceAll('-', widget.separator),
                    style: TextStyle(
                      color: ColorStyle.nwordsColor,
                      fontSize: widget.textSize,
                    ),
                  ),
                ),
                onTap: () {
                  showCalendar();
                },
              ),
              SizedBox(
                width: widget.iconSpacing,
              ),
              InkWell(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: Image.asset('images/icon/icon_calendar_right.png', width: 18, height: 18,),
                ),
                onTap: () {
                  //开始时间和结束时间各加一天，并判断是否超过最大日期 maxDate ，默认当天为最大日期
                  String startTime = times['startTime'];
                  String endTime = times['endTime'];
                  DateTime s = DateTime.parse(startTime);
                  DateTime e = DateTime.parse(endTime);
                  // s = s.add(new Duration(days: 1));
                  // e = e.add(new Duration(days: 1));
                  s = DateTime(s.year,s.month,s.day+1);
                  e = DateTime(e.year,e.month,e.day+1);

                  startTime = s.toString().substring(0, 10);
                  endTime = e.toString().substring(0, 10);
                  debugPrint('s--$startTime -- e -- $endTime');
                  DateTime maxDate = widget.maxDate != null
                      ? DateTime.parse(formatDate(
                          DateTime.parse(widget.maxDate!),
                          [yyyy, '-', mm, '-', dd]))
                      : DateTime.parse(
                          formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
                  debugPrint('maxDate---$maxDate');
                  if (e.isAfter(maxDate)) return; //时间超过 maxDate 直接return
                  saveDate({"startTime": startTime, "endTime": endTime});
                },
              ),
            ],
          ),
        ));
  }
}
