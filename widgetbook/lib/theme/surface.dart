import 'package:flutter/material.dart';
import 'package:ui_kit/theme/theme.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'group.dart';

@UseCase(
  name: 'Color',
  type: ColorThemeData,
  path: '[Theme]',
)
Widget buildColorUseCase(BuildContext context) {
  return WidgetbookGroup(
    label: 'Color',
    children: [
      ColorLabel(
        label: 'Primary',
        color: AppTheme.of(context).color.primary,
      ),
      ColorLabel(
        label: 'blue',
        color: AppTheme.of(context).color.secondary.blue,
      ),
      ColorLabel(
        label: 'dark red',
        color: AppTheme.of(context).color.secondary.darkRed,
      ),
      ColorLabel(
        label: 'red',
        color: AppTheme.of(context).color.secondary.red,
      ),
      ColorLabel(
        label: 'yellow',
        color: AppTheme.of(context).color.secondary.yellow,
      ),
      ColorLabel(
        label: 'green',
        color: AppTheme.of(context).color.secondary.green,
      ),
      ColorLabel(
        label: 'homeBackground',
        color: AppTheme.of(context).color.homeBackground,
      ),
      ColorLabel(
        label: 'pageBackground',
        color: AppTheme.of(context).color.pageBackground,
      ),
      ColorLabel(
        label: 'divider',
        color: AppTheme.of(context).color.divider,
      ),
      ColorLabel(
        label: 'dividerB7',
        color: AppTheme.of(context).color.dividerB7,
      ),
      ColorLabel(
        label: 'dividerE4',
        color: AppTheme.of(context).color.dividerE4,
      ),
      ColorLabel(
        label: 'text primary',
        color: AppTheme.of(context).color.text.primary,
      ),
      ColorLabel(
        label: 'text secondary',
        color: AppTheme.of(context).color.text.secondary,
      ),
      ColorLabel(
        label: 'text normal',
        color: AppTheme.of(context).color.text.normal,
      ),
      ColorLabel(
        label: 'text info',
        color: AppTheme.of(context).color.text.info,
      ),
      ColorLabel(
        label: 'text info secondary',
        color: AppTheme.of(context).color.text.infoSecondary,
      ),
      ColorLabel(
        label: 'icon primary',
        color: AppTheme.of(context).color.icon.primary,
      ),
      ColorLabel(
        label: 'icon secondary',
        color: AppTheme.of(context).color.icon.secondary,
      ),
      ColorLabel(
        label: 'icon info',
        color: AppTheme.of(context).color.icon.info,
      ),
      ColorLabel(
        label: 'icon secondary',
        color: AppTheme.of(context).color.icon.infoSecondary,
      ),
      ColorLabel(
        label: 'icon disabled',
        color: AppTheme.of(context).color.icon.disabled,
      ),
    ],
  );
}

class ColorLabel extends StatelessWidget {
  const ColorLabel({
    super.key,
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Text(label),
      ],
    );
  }
}
