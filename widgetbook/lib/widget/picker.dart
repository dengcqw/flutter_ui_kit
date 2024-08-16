import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/picker/picker_widget.dart';
import 'package:ui_kit/widget/picker/picker_util.dart';
import 'package:ui_kit/widget/picker/fixed_scroll_physics.dart';

final PickData = [
  StringPickerData(value: '1'),
  StringPickerData(value: '2'),
  StringPickerData(value: '3'),
  StringPickerData(value: '4'),
  StringPickerData(value: '5'),
  StringPickerData(value: '6'),
  StringPickerData(value: '7'),
  StringPickerData(value: '8'),
  StringPickerData(value: '9'),
  StringPickerData(value: '10'),
  StringPickerData(value: '11'),
  StringPickerData(value: '12'),
  StringPickerData(value: '13'),
  StringPickerData(value: '14'),
  StringPickerData(value: '15'),
  StringPickerData(value: '16'),
  StringPickerData(value: '17'),
  StringPickerData(value: '18'),
];

@UseCase(
  name: 'PickerWidget',
  type: PickerWidget,
)
Widget buildPickerUseCase(BuildContext context) {
  int pickIndex = 0;
  PickerWidget widget = PickerWidget(
    data: PickData,
    onSelectedItemChanged: (old, index) {
      pickIndex = index;
    },
  );
  return PickerUtil.makeDialogWrapper(
    context: context,
    pickerWidget: widget,
    titleText: '请选择',
    okText: '确认',
    cancelText: '取消',
    onClickOK: () => Navigator.pop(context, pickIndex),
    onClickCancel: () => Navigator.pop(context, null),
  );
}

@UseCase(
  name: 'ActionSheet',
  type: PickerWidget,
)
Widget buildActionSheetPickerUseCase(BuildContext context) {
  return InkWell(
    onTap: () async {
      final index = await PickerUtil.showPickerSingle(context, PickData, initIndex: 1);
      print('pick ${index}');
    },
    child: Text(
      'Show Picker',
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 19,
      ),
    ),
  );
}

