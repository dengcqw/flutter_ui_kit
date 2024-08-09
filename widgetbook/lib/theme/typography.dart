import 'package:flutter/widgets.dart';
import 'package:ui_kit/theme/theme.dart';
import 'package:ui_kit/theme/typography_theme_data.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'group.dart';

@UseCase(
  name: 'Typography',
  type: TypographyThemeData,
  path: '[Theme]',
)
Widget buildTypographyThemeDataUseCase(BuildContext context) {
  return WidgetbookGroup(
    label: 'TextStyle',
    children: [
      Text('导航栏', style: AppTheme.of(context).textStyle.navigatonTitle),
      Text('卡片标题', style: AppTheme.of(context).textStyle.cardTitle),
      Text('选择标题', style: AppTheme.of(context).textStyle.selectionTitle),
      Text('列表标题', style: AppTheme.of(context).textStyle.listTitle),
      Text('列表内容', style: AppTheme.of(context).textStyle.listContent),
    ],
  );
}
