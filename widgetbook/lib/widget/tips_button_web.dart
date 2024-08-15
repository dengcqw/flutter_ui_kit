import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/tips_button_web.dart';

@UseCase(
  name: 'TipsButtonWeb',
  type: TipsButtonWeb,
)
Widget buildTipsButtonWebUseCase(BuildContext context) {
  return TipsButtonWeb(
    url: 'generate/ZT_OverviewWidgetTwo_zh',
    textColor: Color(0xFF898989),
  );
}
