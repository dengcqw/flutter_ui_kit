import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/tips_button.dart';

@UseCase(
  name: 'TipsButton',
  type: TipsButton,
)
Widget buildTipsButtonUseCase(BuildContext context) {
  return const TipsButton();
}
