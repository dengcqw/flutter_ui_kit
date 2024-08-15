import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/jt_tabs.dart';

const tabNames = ['近七天', '近一月', '近半年'];

@UseCase(
  name: 'middleRed',
  type: JTTabs,
)
Widget buildJTTabsmiddleRedUseCase(BuildContext context) {
  return JTTabs.middleRed(
    names: tabNames,
  );
}

@UseCase(
  name: 'rectangle',
  type: JTTabs,
)
Widget buildJTTabsrectangleUseCase(BuildContext context) {
  return JTTabs.rectangle(
    names: tabNames,
  );
}

@UseCase(
  name: 'red',
  type: JTTabs,
)
Widget buildJTTabsredUseCase(BuildContext context) {
  return JTTabs.red(
    names: tabNames,
  );
}

@UseCase(
  name: 'spaceRed',
  type: JTTabs,
)
Widget buildJTTabsspaceRedUseCase(BuildContext context) {
  return JTTabs.spaceRed(
    names: tabNames,
    space: context.knobs.double.input(label: 'space', initialValue: 10),
  );
}
