import 'package:flutter/material.dart';

class TypographyThemeData {
  const TypographyThemeData({
    required this.color,
  });

  final Color color;

  /// 导航栏标题
  TextStyle get navigatonTitle {
    return TextStyle(color: color, fontSize: 27);
  }

  /// 卡片标题
  TextStyle get cardTitle {
    return TextStyle(color: color, fontSize: 25);
  }

  /// 选择栏标题
  TextStyle get selectionTitle {
    return TextStyle(color: color, fontSize: 23);
  }

  /// 列表标题
  TextStyle get listTitle {
    return TextStyle(color: color, fontSize: 21);
  }

  /// 列表内容
  TextStyle get listContent {
    return TextStyle(color: color, fontSize: 20);
  }

  /// 辅助性文字
  TextStyle regular(double fontSize) {
    return TextStyle(color: color, fontSize: fontSize);
  }
}
