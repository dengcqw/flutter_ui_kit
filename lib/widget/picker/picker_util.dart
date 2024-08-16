import 'package:flutter/material.dart';
import 'package:ui_kit/widget/picker/fixed_scroll_physics.dart';
import 'package:ui_kit/widget/picker/picker_widget.dart';

class PickerUtil {
  /// picker header
  static Widget makeDialogWrapper({
    required BuildContext context,
    required Widget pickerWidget,
    required String titleText,
    required String okText,
    required String cancelText,
    required VoidCallback onClickOK,
    required VoidCallback onClickCancel,
  }) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
      child: Column(
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () => onClickCancel.call(),
                  child: SizedBox(
                    width: 85,
                    height: 46,
                    child: Center(
                        child: Text(
                      cancelText,
                      style: const TextStyle(
                          color: Color(0xFF61666D), fontSize: 13),
                    )),
                  )),
              Expanded(
                child: Center(
                    child: Text(
                  titleText,
                  style: const TextStyle(
                      color: Color(0xFF171921),
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
              ),
              InkWell(
                  onTap: () => onClickOK.call(),
                  child: SizedBox(
                    width: 85,
                    height: 46,
                    child: Center(
                        child: Text(
                      okText,
                      style: const TextStyle(
                          color: Color(0xFFFF0607), fontSize: 13),
                    )),
                  )),
            ],
          ),
          pickerWidget
        ],
      ),
    );
  }

  static Future<int?> showPickerSingle(
    BuildContext context,
    List<IPickerData> list, {
    String titleText = '请选择',
    String okText = '确认',
    String cancelText = '取消',
    int initIndex = 0,
  }) {
    int pickIndex = initIndex;
    PickerWidget widget = PickerWidget(
      data: list,
      onSelectedItemChanged: (old, index) {
        pickIndex = index;
      },
    );
    return showModalBottomSheet<int?>(
      context: context,
      builder: (context) => SizedBox(
        height: 46 + 5 * 40,
        child: makeDialogWrapper(
          context: context,
          pickerWidget: widget,
          titleText: titleText,
          okText: okText,
          cancelText: cancelText,
          onClickOK: () => Navigator.pop(context, pickIndex),
          onClickCancel: () => Navigator.pop(context, null),
        ),
      ),
    );
  }

  static Future<int?> showStringPickerSingle(
    BuildContext context,
    List<String> list, {
    String titleText = '请选择',
    String okText = '确认',
    String cancelText = '取消',
    int initIndex = 0,
  }) {
    return showPickerSingle(
        context, list.map((value) => StringPickerData(value: value)).toList(),
        titleText: titleText,
        okText: okText,
        cancelText: cancelText,
        initIndex: initIndex);
  }
}
