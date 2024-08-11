import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/styled_tab_bar.dart';

@UseCase(
  name: 'TabBar',
  type: StyledTabBar,
)
Widget buildTabBarUseCase(BuildContext context) {
  return StyledTabBar(
    isScrollable: context.knobs.boolean(label: '支持滚动'),
    noBgColor: context.knobs.boolean(label: '隐藏白色背景'),
    noBorderLine: context.knobs.boolean(label: '隐藏分割线', initialValue: true),
    fontSize: context.knobs.double
        .slider(label: 'font size', initialValue: 14, min: 10, max: 25),
    indicatorWidth:
        context.knobs.double.input(label: '指示器宽度', initialValue: 20),
    tabs: const ['全部', '网点', '代理商', '总部'],
    onTap: (index) {
      print('TabBar onTap $index');
    },
  );
}
