import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/expand_entry.dart';

@UseCase(
  name: 'ExpandEntry',
  type: ExpandEntry,
)
Widget buildExpanEntryUseCase(BuildContext context) {
  return const ExpandEntry(
    expanded: false,
    title: '总部',
  );
}
