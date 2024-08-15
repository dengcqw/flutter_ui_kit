import 'package:flutter/material.dart';

/// 把传入的数值转换成'xx时xx分'格式
class HourMinuteTimeLabel extends StatelessWidget {
  final int? minutes;
  final int seconds;
  final Color textColor;
  const HourMinuteTimeLabel({
    required this.minutes,
    this.seconds = 0,
    this.textColor = Colors.red,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (minutes == null) {
      return Text(
        '--',
        style: TextStyle(
            fontSize: 16, color: textColor, fontWeight: FontWeight.w700),
      );
    }
    final totalSec = minutes! * 60 + seconds;
    final hh = totalSec ~/ 3600;
    final mm = totalSec ~/ 60 % 60;
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          if (hh >= 1)
            TextSpan(
              text: hh.toStringAsFixed(0),
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.w700),
            ),
          if (hh >= 1)
            TextSpan(
              text: '时',
              style: TextStyle(fontSize: 12, color: textColor),
            ),
          TextSpan(
            text: mm.toStringAsFixed(0),
            style: TextStyle(
                fontSize: 16, color: textColor, fontWeight: FontWeight.w700),
          ),
          TextSpan(
            text: '分',
            style: TextStyle(fontSize: 12, color: textColor),
          )
        ],
      ),
    );
  }
}
