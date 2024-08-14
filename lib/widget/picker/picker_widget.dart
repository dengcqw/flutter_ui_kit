import 'package:flutter/material.dart';
import 'package:ui_kit/color_style.dart';
import 'package:ui_kit/extension/jt_extension.dart';
import 'package:ui_kit/widget/picker/fixed_scroll_physics.dart';
import 'package:collection/collection.dart';

// 滚动结束回调
typedef PickerIndexChanged<T> = void Function(T oldValue, T newValue);

// 彻底被选中的回调
typedef PickerTripleFinished<T> = void Function(int firstIndex, int secondIndex,
    int tripleIndex, T firstValue, T secondValue, T tripleValue);

class IPickerData {
  final String defName;

  final int? id;

  displayName() {
    return defName;
  }

  displayChild() {
    return [];
  }

  IPickerData({this.defName = '', this.id});

  @override
  String toString() {
    return 'IPickerData{defName: $defName, id: $id}';
  }
}

/// 单个选择器控件
/// picker_widget
/// 2023/5/9
/// @author wym
class PickerWidget<T extends IPickerData> extends StatefulWidget {
  final String hintText;
  final double itemHeight; // 每一项的高度
  final int visiableCount;
  final List<T> data;
  final PickerIndexChanged<int>? onSelectedItemChanged;
  final FixedScrollController controller;

  const PickerWidget({
    Key? key,
    this.hintText = '请选择',
    this.onSelectedItemChanged,
    this.itemHeight = 40.0,
    this.visiableCount = 5,
    required this.data,
    required this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  int currentIndex = 0;
  // 切换前选择的下标
  int oldIndex = 0;

  @override
  void initState() {
    currentIndex = widget.controller.initialItem;
    debugPrint('picker_widget ==> 初始选中: $currentIndex');
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 高亮行之前的行数
    final int topCount = widget.visiableCount ~/ 2;
    final double itemHeight = widget.itemHeight;

    final emptyItems =
        List.generate(topCount, (index) => IPickerData(defName: ''));
    final List<IPickerData> data = [
      ...emptyItems,
      ...widget.data,
      ...emptyItems
    ];

    return SizedBox(
      height: itemHeight * widget.visiableCount,
      child: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notify) {
              final PickerIndexChanged<int>? listener =
                  widget.onSelectedItemChanged;
              final ScrollMetrics metrics = notify.metrics;
              if ((metrics is! FixedExtentMetrics)) return false;
              if (listener == null) return false;
              final FixedExtentMetrics fixedMetrics = metrics;
              final currentIndex = fixedMetrics.itemIndex;

              int oldIndexReal; // 真实对应数据的下标
              int currentIndexReal; // 真实对应数据的下标
              oldIndexReal = oldIndex;
              currentIndexReal = currentIndex;

              if (this.currentIndex == currentIndex) {
                // 发生实际变化再刷新
                return false;
              }

              if (notify is ScrollUpdateNotification) {
                listener.call(oldIndexReal, currentIndexReal);
                setState(() {
                  this.currentIndex = currentIndex;
                });
              } else if (notify is ScrollEndNotification) {
                listener.call(oldIndexReal, currentIndexReal);
                setState(() {
                  this.currentIndex = currentIndex;
                });
              } else if (notify is ScrollStartNotification) {
                oldIndex = fixedMetrics.itemIndex;
              }

              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                children: data.mapIndexed((index, itemData) {
                  final String displayName = itemData.displayName();
                  if (displayName.isEmpty)
                    return SizedBox(
                      height: itemHeight,
                    );

                  final isSelected = index == currentIndex + topCount;

                  return GestureDetector(
                    onTap: () {
                      widget.controller.animateToItem(index - topCount,
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeIn);
                    },
                    child: SizedBox(
                      height: itemHeight,
                      child: Center(
                        child: Text(
                          displayName,
                          style: TextStyle(
                            color: isSelected
                                ? ColorStyle.appColor
                                : ColorStyle.nwordsColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              controller: widget.controller,
              physics: FixedScrollPhysics(itemHeight),
            ),
          ),
          IgnorePointer(
            child: Container(
              margin: EdgeInsets.only(top: itemHeight * topCount),
              height: itemHeight,
              //color: Colors.grey.withAlpha(50),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFEBEBEB), width: 0.5),
                  bottom: BorderSide(color: Color(0xFFEBEBEB), width: 0.5),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ListView 无法滚动到底部，这里差了6像素，改用ScrollView
