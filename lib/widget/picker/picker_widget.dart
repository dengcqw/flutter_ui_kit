import 'package:flutter/material.dart';
import 'package:ui_kit/color_style.dart';
import 'package:ui_kit/extension/jt_extension.dart';
import 'package:ui_kit/widget/picker/fixed_scroll_physics.dart';
import 'package:collection/collection.dart';

// 滚动结束回调
typedef PickerIndexChanged<T> = void Function(T oldValue, T newValue);

class IPickerData {
  String? displayName() {
    return null;
  }

  Widget? displayChild() {
    return null;
  }
}

class StringPickerData extends IPickerData {
  String value;

  @override
  String? displayName() {
    return value;
  }

  StringPickerData({required this.value});
}

/// 单个选择器控件
/// picker_widget
/// 2023/5/9
/// @author wym
class PickerWidget<T extends IPickerData> extends StatefulWidget {
  final String hintText;
  final double itemHeight; // 每一项的高度
  final int visiableCount;
  final int initIndex;
  final List<T> data;
  final PickerIndexChanged<int>? onSelectedItemChanged;

  const PickerWidget({
    required this.data,
    Key? key,
    this.hintText = '请选择',
    this.onSelectedItemChanged,
    this.itemHeight = 40.0,
    this.visiableCount = 5,
    this.initIndex = 0,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget> {
  int currentIndex = 0;
  // 切换前选择的下标
  int oldIndex = 0;
  late FixedScrollController scrollController;

  @override
  void initState() {
    scrollController = FixedScrollController(initialItem: widget.initIndex);
    currentIndex = widget.initIndex;
    debugPrint('picker_widget ==> 初始选中: $currentIndex');
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 高亮行之前的行数
    final int topCount = widget.visiableCount ~/ 2;
    final double itemHeight = widget.itemHeight;

    final emptyItems =
        List.generate(topCount, (index) => IPickerData());
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
                  // 使用自定义组件
                  final Widget? customChild = itemData.displayChild();
                  if (customChild != null) {
                    return GestureDetector(
                      onTap: () {
                        scrollController.animateToItem(index - topCount,
                            duration: const Duration(milliseconds: 150),
                            curve: Curves.easeIn);
                      },
                      child: SizedBox(
                        height: itemHeight,
                        child: customChild!,
                      ),
                    );
                  }

                  // 使用字符
                  final String? displayName = itemData.displayName();
                  if (displayName == null || displayName!.isEmpty)
                    return SizedBox(
                      height: itemHeight,
                    );

                  final isSelected = index == currentIndex + topCount;

                  return GestureDetector(
                    onTap: () {
                      scrollController.animateToItem(index - topCount,
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
              controller: scrollController,
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
