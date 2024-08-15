import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/time_label.dart';

@UseCase(
  name: 'HourMinuteTimeLabel',
  type: HourMinuteTimeLabel,
)
Widget buildHourMinuteTimeLabelUseCase(BuildContext context) {
  return HourMinuteTimeLabel(
    minutes: context.knobs.int.input(label: 'minutes', initialValue: 100),
    seconds: context.knobs.int.input(label: 'seconds', initialValue: 60),
  );
}
