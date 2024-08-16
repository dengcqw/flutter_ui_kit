///日历时间控件区间选择
class RangeDayModel {
  DateTime startTime;
  DateTime endTime;

  RangeDayModel({required this.startTime,required this.endTime});

  String get endTimeString {
    return endTime.toString().substring(0,10);
  }

  String get startTimeString {
    return startTime.toString().substring(0,10);
  }

  int get differenceDay {
    return endTime.difference(startTime).inDays;
  }
}




