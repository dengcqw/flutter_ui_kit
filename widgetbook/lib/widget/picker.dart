import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/picker/picker_widget.dart';
import 'package:ui_kit/widget/picker/picker_util.dart';
import 'package:ui_kit/widget/picker/fixed_scroll_physics.dart';

final PickData = [
  IPickerData(defName: '1', id: 1),
  IPickerData(defName: '2', id: 2),
  IPickerData(defName: '3', id: 3),
  IPickerData(defName: '4', id: 4),
  IPickerData(defName: '5', id: 4),
  IPickerData(defName: '6', id: 4),
  IPickerData(defName: '7', id: 4),
  IPickerData(defName: '8', id: 4),
  IPickerData(defName: '9', id: 4),
  IPickerData(defName: '10', id: 4),
  IPickerData(defName: '11', id: 4),
  IPickerData(defName: '12', id: 4),
  IPickerData(defName: '13', id: 4),
  IPickerData(defName: '14', id: 4),
  IPickerData(defName: '15', id: 4),
  IPickerData(defName: '16', id: 4),
  IPickerData(defName: '17', id: 4),
  IPickerData(defName: '18', id: 4),
];

@UseCase(
  name: 'PickerWidget',
  type: PickerWidget,
)
Widget buildPickerUseCase(BuildContext context) {
  FixedScrollController scrollController =
      FixedScrollController(initialItem: 2);
  int pickIndex = 0;
  PickerWidget widget = PickerWidget(
    data: PickData,
    controller: scrollController,
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

