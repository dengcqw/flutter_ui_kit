import 'package:flutter/material.dart';

abstract class ColorStyle {
  // App 主题色
  static const Color appColor = Color(0xFFE6262C);

  // 标题颜色
  static const Color titleColor = Color(0xFF171921);

  // 重要文字颜色
  static const Color /**/iwordsColor = Color(0xFF3C3C3C);

  // 常规文字颜色/**/
  static const Color nwordsColor = Color(0xFF61666D);

  // 次要文字颜色
  static const Color swordsColor = Color(0xFF999999);
  // 次要文字颜色
  static const Color swordsColor2 = Color(0xFF333333);

  // 提示文字颜色
  static const Color tipsColor = Color(0xFFB7B7B7);

  //灰色文字颜色
  static const Color grayColor = Color(0xFF7A7A7A);


  // 边框颜色 三种
  // 边框颜色统一
  static const Color borderColor1 = Color(0xFFE4E4E4);
  static const Color borderColor2 = Color(0xFFE4E4E4);
  static const Color borderColor3 = Color(0xFFE4E4E4);

  // 边框背景色
  static const Color borderBackgroundColor = Color(0xFFF5F6F9);

  // 辅色-绿色
  static const Color greenColor = Color(0xFF0EC02F);

  // 辅色-橘色
  static const Color orangeColor = Color(0xFFFFA540);

  // 辅色-橘色
  static const Color orangeColors = Color(0xFFF63A40);

  // 辅色-黄色
  static const Color yellow = Color(0xFFFDF2D0);

  // 辅色-蓝色
  static const Color blueColor = Color(0xFF5E83FF);

  // 辅色-淡红色背景
  static const Color redBgColor = Color(0x0DE6262C);

  // 绿色-箭头
  static const Color greenColors = Color(0xFF1DC11D);

  // 背景色
  static const Color backgroundColor = Color(0xFFF3F2F7);

  // 首页背景色
  static const Color homeBackgroundColor = Color(0xFFEEEEEE);

  // 首页背景色
  static const Color textBackgroundColor = Color(0xFFE6F8EA);

  // 红色
  static const Color commonRedColor = Color(0xFFE60012);
}
// 全局配置
class ColorConfig {
  /// 主题颜色
  static const int _primaryColorValue = 0xFFE6262C;
  static const Color primaryColor = Color(_primaryColorValue);
  static const MaterialColor primarySwatchColor = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xFFE6262C),
      100: Color(0xFFE6262C),
      200: Color(0xFFE6262C),
      300: Color(0xFFE6262C),
      400: Color(0xFFE6262C),
      500: Color(_primaryColorValue),
      600: Color(0xFFE6262C),
      700: Color(0xFFE6262C),
      800: Color(0xFFE6262C),
      900: Color(0xFFE6262C),
    },
  );
}

