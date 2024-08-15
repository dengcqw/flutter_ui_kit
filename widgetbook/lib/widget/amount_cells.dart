import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import '../knob/text_style_knob.dart';

import 'package:ui_kit/widget/amount_cells.dart';

@UseCase(
  name: 'PercentNum',
  type: PercentNum,
)
Widget buildPercentNumUseCase(BuildContext context) {
  return PercentNum(
    ratio: context.knobs.double.input(label: 'ratio', initialValue: 0.5),
    textStyle: context.knobs.textStyle(label: 'textStyle', initialValue: TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
    hidePlus: context.knobs.boolean(label: 'hidePlus'),
  );
}
