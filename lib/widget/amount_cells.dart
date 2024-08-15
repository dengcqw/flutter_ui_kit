import 'package:flutter/material.dart';
import 'package:ui_kit/color_style.dart';
import 'package:ui_kit/widget/digit_label.dart';

/// 显示百分数，显示正负号表示增长
class PercentNum extends StatelessWidget {
  /// 没有乘100的数值, 50%是 0.5
  final num? ratio;

  /// 设置字体大小，忽略颜色
  final TextStyle textStyle;

  /// 隐藏正号
  final bool hidePlus;
  const PercentNum({
    this.ratio,
    this.textStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    this.hidePlus = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (ratio == null) return const SizedBox();

    var color = ColorStyle.titleColor;
    var prefixChar = '';
    var iconValue = 0;
    if (ratio! > 0) {
      color = ColorStyle.appColor;
      if (!hidePlus) {
        prefixChar = '+';
      }
      iconValue = 0xe713;
    } else if (ratio! < 0) {
      color = ColorStyle.greenColor;
      iconValue = 0xe71b;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$prefixChar${(ratio! * 100).toStringAsFixed(2)}%',
          style: textStyle.copyWith(color: color),
        ),
        ratio != 0
            ? Icon(
                IconData(
                  iconValue,
                  fontFamily: 'myIcon',
                  fontPackage: 'ui_kit',
                ),
                color: color,
                size: textStyle.fontSize! - 3,
              )
            : const SizedBox(),
      ],
    );
  }
}

// 数据汇总重点数据cell
class PrimaryAmountCell extends StatelessWidget {
  final String title;
  final num value;

  /// 没有乘100的数值, 50%是 0.5
  final num? ratio;

  const PrimaryAmountCell({
    required this.title,
    required this.value,
    this.ratio,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ColorStyle.swordsColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DigitLabel(
              value: value,
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: ColorStyle.titleColor,
                fontSize: 28,
              ),
            ),
            const SizedBox(width: 6),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: PercentNum(
                ratio: ratio,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AmountData {
  // 标题
  final String title;
  // 数值
  final num? value;
  // value左边的环比，有箭头和加减符号
  final num? ratio;
  // 数值是百分比
  final bool isPercent;
  // 百分比数值显示箭头和颜色
  final bool styledPercentValue;

  const AmountData(
      {required this.title,
      this.value,
      this.ratio,
      this.isPercent = false,
      this.styledPercentValue = false});
}

// 上标题，下数值和比例
// 用于数据汇总次要数据
class AmountItem extends StatelessWidget {
  final AmountData data;
  String get title {
    return data.title;
  }

  num get value {
    return data.value ?? 0;
  }

  num? get ratio {
    return data.ratio;
  }

  const AmountItem({
    required this.data,
    Key? key,
  }) : super(key: key);

  Widget valueWidget() {
    if (data.isPercent) {
      if (data.styledPercentValue) {
        return PercentNum(
          ratio: value,
          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          hidePlus: true,
        );
      } else {
        return Text(
          '${(value * 100).toStringAsFixed(2)}%',
          style: const TextStyle(
            color: ColorStyle.titleColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        );
      }
    } else {
      return DigitLabel(
        value: value,
        textStyle: TextStyle(
          fontSize: 18,
          color: ColorStyle.titleColor,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: ColorStyle.swordsColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              valueWidget(),
              const SizedBox(width: 2),
              PercentNum(
                ratio: ratio,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 一行多列汇总
class AmountsCell extends StatelessWidget {
  final List<AmountData> datas;
  final bool showTopDiv;
  const AmountsCell({
    required this.datas,
    this.showTopDiv = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    for (var i = 0, len = datas.length; i < len; ++i) {
      if (i != 0) {
        children.add(
          Container(
            width: 0.5,
            height: 35,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: ColorStyle.borderColor1,
          ),
        );
      }
      children.add(Expanded(
        child: AmountItem(
          data: datas[i],
        ),
      ));
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: showTopDiv
          ? const BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: ColorStyle.borderColor1,
                ),
              ),
            )
          : null,
      child: Row(
        children: children,
      ),
    );
  }
}

