import 'package:flutter/material.dart';
import 'package:ui_kit/color_style.dart';
import '../toast.dart';
import 'date_picker.dart';

class FlanRangeCalendar extends StatefulWidget {
  const FlanRangeCalendar({
    required this.startTime,
    required this.endTime,
    Key? key,
    this.callBack,
    this.maxDate, //可选最大日期
    this.maxRange = 365, //最大区间默认一年
  }) : super(key: key);
  final Function? callBack;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime? maxDate;
  final int maxRange;

  @override
  State<FlanRangeCalendar> createState() {
    return _FlanRangeCalendarState();
  }
}

class _FlanRangeCalendarState extends State<FlanRangeCalendar> {
  late DateTime startTime;
  late DateTime endTime;
  late DateTime maxDate;

  @override
  void initState() {
    super.initState();
    startTime = widget.startTime;
    endTime = widget.endTime;
    maxDate = widget.maxDate ?? DateTime.now();
  }

  Future<void> showFlanRangeCalendar() async {
    showRangeCalendar(
      context,
      startDateTime: startTime,
      endDateTime: endTime,
      minDateTime: DateTime.now().subtract(const Duration(days: 365)),
      maxDateTime: maxDate,
      maxRange: widget.maxRange,
    ).then((result) {
      if (result == null) return;
      var start = result.startDateTime!.millisecondsSinceEpoch;
      var end = result.endDatetime!.millisecondsSinceEpoch;
      var long = end - start;
      if (long > 31536000000) {
        Toast.toast(context, '仅支持查看一年内的数据');
        return;
      }
      setDate(startTime: result.startDateTime, endTime: result.endDatetime);
    });
  }

  void setDate({DateTime? startTime, DateTime? endTime}) {
    setState(() {
      this.startTime = startTime!;
      this.endTime = endTime!;
    });
    widget.callBack?.call({"startTime": startTime, "endTime": endTime});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(minWidth: 138),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: const Icon(
                      IconData(
                        0xe71d,
                        fontFamily: 'myIcon',
                        fontPackage: 'ui_kit',
                      ),
                      color: ColorStyle.tipsColor,
                      size: 24),
                ),
                onTap: () {
                  setDate(
                      startTime: startTime.subtract(const Duration(days: 1)),
                      endTime: endTime.subtract(const Duration(days: 1)));
                },
              ),
              InkWell(
                child: Text(
                  '${startTime.toString().substring(0, 10)} - ${endTime.toString().substring(0, 10)}',
                  style: const TextStyle(
                    color: ColorStyle.nwordsColor,
                    fontSize: 14,
                  ),
                ),
                onTap: () {
                  showFlanRangeCalendar();
                },
              ),
              InkWell(
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  child: const Icon(
                      IconData(
                        0xe71e,
                        fontFamily: 'myIcon',
                        fontPackage: 'ui_kit',
                      ),
                      color: ColorStyle.tipsColor,
                      size: 24),
                ),
                onTap: () {
                  //开始时间和结束时间各加一天，并判断是否超过最大日期 maxDate ，默认当天为最大日期
                  DateTime e = endTime.add(const Duration(days: 1));
                  if (e.isAfter(maxDate)) return; //时间超过 maxDate 直接return
                  setDate(
                      startTime: startTime.add(const Duration(days: 1)),
                      endTime: endTime.add(const Duration(days: 1)));
                },
              ),
            ],
          ),
        ));
  }
}
