import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/title_item.dart';

@UseCase(
  name: 'TitleItem',
  type: TitleItem,
)
Widget buildTitleItemUseCase(BuildContext context) {
  return TitleItem(
    showMore: context.knobs.boolean(label: 'showMore'),
    title: context.knobs.string(label: 'title', initialValue: '客诉量'),
  );
}
