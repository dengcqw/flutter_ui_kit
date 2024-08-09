import 'package:flutter/widgets.dart';
import 'typography_theme_data.dart';

class AppTheme extends InheritedWidget {
  const AppTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<AppTheme>();
    return widget!.data;
  }

  @override
  bool updateShouldNotify(covariant AppTheme oldWidget) {
    return data != oldWidget.data;
  }
}

class AppThemeData {
  const AppThemeData({
    this.textStyle = const TypographyThemeData(color: Color(0xFF171921)),
    this.color = const ColorThemeData(),
    this.radius = const RadiusThemeData(),
    this.spacing = const SpacingThemeData(),
  });

  final SpacingThemeData spacing;
  final TypographyThemeData textStyle;
  final RadiusThemeData radius;
  final ColorThemeData color;
}

class SpacingThemeData {
  const SpacingThemeData({
    this.none = 0,
    this.card = 10,
    this.page = 10,
  });
  final double none;

  /// 卡片上下距离
  final double card;

  /// 页面边距
  final double page;
}

class RadiusThemeData {
  const RadiusThemeData({
    this.none = 0,
    this.card = 8,
  });
  final double none;
  final double card;
}

class ColorThemeData {
  const ColorThemeData({
    this.primary = const Color(0xFFE6262C),
    this.secondary = const SecondaryColor(),
    this.text = const TextColor(),
    this.icon = const IconColor(),
    this.homeBackground = const Color(0xFFEAEAEA),
    this.pageBackground = const Color(0xFFF5F6F9),
    this.divider = const Color(0xFFEBEBEB),
    this.dividerE4 = const Color(0xFFE4E4E4),
    this.dividerB7 = const Color(0xFFB7B7B7),
  });

  /// 主题色 #E6262C
  final Color primary;

  /// 辅助色
  final SecondaryColor secondary;

  /// 文字颜色
  final TextColor text;

  /// 图标颜色
  final IconColor icon;

  /// #EAEAEA 首页背景颜色
  final Color homeBackground;

  /// #F5F6F9 常规页面背景颜色
  final Color pageBackground;

  /// #EBEBEB 用于顶部导航分割线、卡片分割线 及底Bar分割线
  final Color divider;

  /// #E4E4E4 用于卡片Tab切换按钮分割线
  final Color dividerE4;

  /// #B7B7B7 用于次要按钮分割线，如首页编辑卡片分割线
  final Color dividerB7;
}

/// 用于图标和其他点缀颜色
class SecondaryColor {
  const SecondaryColor({
    this.darkRed = const Color(0xFFF14F4F),
    this.red = const Color(0xFFF63A40),
    this.blue = const Color(0xFF426DFF),
    this.yellow = const Color(0xFFFFA53F),
    this.green = const Color(0xFF0EC02F),
  });

  /// #F14F4F
  final Color darkRed;

  /// #F63A40
  final Color red;

  /// #426DFF
  final Color blue;

  /// #FFA53F
  final Color yellow;

  /// #0EC02F
  final Color green;
}

/// 文字颜色
/// 按重要性分5等级
class TextColor {
  const TextColor({
    this.primary = const Color(0xFF171921),
    this.secondary = const Color(0xFF3C3C3C),
    this.normal = const Color(0xFF61666D),
    this.info = const Color(0xFF999999),
    this.infoSecondary = const Color(0xFFB7B7B7),
  });

  /// #171921  用于一级重要信息，导航栏标题、关键功能操作入口
  final Color primary;

  /// #3C3C3C 用于次重要信息，如首页消息提示，次重要数据等
  final Color secondary;

  /// #61666D 用于一般重要功能操作入口，如工作台标题文字、时间控件文字等
  final Color normal;

  /// #999999 用于次要信息、辅助功能，如提示说明文字
  final Color info;

  /// #B7B7B7 用于非重要信息，如填写指引、最弱一级文字
  final Color infoSecondary;
}

/// 图标颜色
/// 按重要性分5等级
class IconColor {
  const IconColor({
    this.primary = const Color(0xFF3C3C3C),
    this.secondary = const Color(0xFF61666D),
    this.info = const Color(0xFF999999),
    this.infoSecondary = const Color(0xFFB7B7B7),
    this.disabled = const Color(0xFFD8D8D8),
  });

  /// #3C3C3C  用于顶部导航图标
  final Color primary;

  /// #61666D 用于底Bar功能项图标
  final Color secondary;

  /// #999999 用于次要图标，如输入框提示图标
  final Color info;

  /// #B7B7B7 用于次要图标，如卡片标题提示图标， 时间控件图标等
  final Color infoSecondary;

  /// #D8D8D8 用于不可点击按钮，置灰状态情况下取色
  final Color disabled;
}
