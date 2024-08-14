import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/search_bar.dart';

@UseCase(
  name: 'JTSearchBar',
  type: JTSearchBar,
)
Widget buildJTSearchBarUseCase(BuildContext context) {
  return JTSearchBar(
    hintText: '请输入要查询的内容',
  );
}
