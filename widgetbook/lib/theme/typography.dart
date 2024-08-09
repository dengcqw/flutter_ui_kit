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
  const data = 'The lazy dog jumped over the quick brown fox';

  return WidgetbookGroup(
    label: 'Typography',
    children: [
      Text(data, style: AppTheme.of(context).typography.displayRegular32),
      Text(data, style: AppTheme.of(context).typography.headingSemibold20),
      Text(data, style: AppTheme.of(context).typography.headingMedium24),
      Text(data, style: AppTheme.of(context).typography.bodyRegular12),
      Text(data, style: AppTheme.of(context).typography.bodyRegular14),
      Text(data, style: AppTheme.of(context).typography.bodyMedium16),
      Text(data, style: AppTheme.of(context).typography.bodySemiBold16),
      Text(data, style: AppTheme.of(context).typography.labelMedium11),
      Text(data, style: AppTheme.of(context).typography.labelMedium14),
      Text(data, style: AppTheme.of(context).typography.subheadingRegular16),
      Text(data, style: AppTheme.of(context).typography.subheadingMedium20),
      Text(data, style: AppTheme.of(context).typography.logoSemiBold20),
    ],
  );
}
