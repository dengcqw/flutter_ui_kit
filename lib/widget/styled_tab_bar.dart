import 'package:flutter/material.dart';
import '../theme/theme.dart';

/// 封装官方TabBar, 用于页面顶部
class StyledTabBar extends StatefulWidget {
  /// 1 Icon或Text组件
  /// 2 字符串
  /// 3 IconData
  final List<dynamic> tabs;

  /// 传入外部控制器，用于TabView联动
  final TabController? controller;

  /// 单独使用时，可以传此回调
  final ValueChanged<int>? onTap;

  /// 不可滑动时，分均分宽度，可滑动时text会展开
  final bool isScrollable;

  /// 固定宽度或和label同宽
  final double? indicatorWidth;

  final double height;
  final double fontSize;

  /// 不设置背景色，由外界自定义
  final bool noBgColor;
  final bool noBorderLine;

  const StyledTabBar({
    required this.tabs,
    this.isScrollable = false,
    this.noBgColor = false,
    this.noBorderLine = false,
    this.indicatorWidth,
    this.controller,
    this.onTap,
    this.height = 40,
    this.fontSize = 14,
    Key? key,
  }) : super(key: key);

  @override
  StyledTabBarState createState() => StyledTabBarState();
}

class StyledTabBarState extends State<StyledTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    assert(widget.controller != null || widget.onTap != null);
    _controller = widget.controller != null
        ? widget.controller!
        : TabController(length: widget.tabs.length, vsync: this);

    if (widget.onTap != null) {
      _controller.addListener(() {
        final tabNum = _controller.index;
        //TabBar的第二种实现方式 TabController是有坑的。
        // 问题：这个监听在点击切换tab的时候会回调两次，左右滑动切换tab正常调用一次
        // 二、原因
        // 点击切换tab的时候执行了一个动画效果，滑动切换的时候是没有的，在这个过程中触发了一次Listener。
        if (tabNum == _controller.animation?.value) {
          widget.onTap!(tabNum);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColor = AppTheme.of(context).color.primary;
    final borderColor = AppTheme.of(context).color.divider;

    return Container(
      decoration: BoxDecoration(
        color: widget.noBgColor ? null : Colors.white,
        border: widget.noBorderLine
            ? null
            : Border(
                bottom: BorderSide(width: 0.5, color: borderColor),
              ),
      ),
      height: widget.height,
      child: TabBar(
        tabs: widget.tabs.map((e) {
          if (e is String) {
            return Tab(height: 38, text: e);
          } else if (e is IconData) {
            return Tab(height: 38, icon: Icon(e));
          } else if (e is Icon) {
            return Tab(height: 38, icon: e);
          } else if (e is Text) {
            return Tab(height: 38, child: e);
          } else {
            return const Tab(height: 38, text: '--');
          }
        }).toList(),
        controller: _controller,
        isScrollable: widget.isScrollable,
        labelColor: appColor,
        labelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: widget.fontSize,
        ),
        unselectedLabelColor: const Color(0xFF333333),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: widget.fontSize,
        ),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: appColor,
        indicator: widget.indicatorWidth != null
            ? UnderlineTabIndicator(
                borderRadius: const BorderRadius.all(Radius.circular(1.5)),
                borderSide: BorderSide(color: appColor, width: 2),
                width: widget.indicatorWidth,
              )
            : null,
      ),
    );
  }
}

class UnderlineTabIndicator extends Decoration {
  const UnderlineTabIndicator({
    this.borderRadius,
    this.borderSide = const BorderSide(width: 2, color: Colors.white),
    this.insets = EdgeInsets.zero,
    this.width,
  });

  final BorderRadius? borderRadius;

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  final double? width;

  @override
  Decoration? lerpFrom(Decoration? a, double t) {
    if (a is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        insets: EdgeInsetsGeometry.lerp(a.insets, insets, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  Decoration? lerpTo(Decoration? b, double t) {
    if (b is UnderlineTabIndicator) {
      return UnderlineTabIndicator(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        insets: EdgeInsetsGeometry.lerp(insets, b.insets, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _UnderlinePainter(this, borderRadius, onChanged);
  }

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);

    if (width != null) {
      double cw = (indicator.left + indicator.right) / 2;
      return Rect.fromLTWH(cw - width! / 2, indicator.bottom - borderSide.width,
          width!, borderSide.width);
    }

    return Rect.fromLTWH(
      indicator.left,
      indicator.bottom - borderSide.width,
      indicator.width,
      borderSide.width,
    );
  }

  @override
  Path getClipPath(Rect rect, TextDirection textDirection) {
    if (borderRadius != null) {
      return Path()
        ..addRRect(
            borderRadius!.toRRect(_indicatorRectFor(rect, textDirection)));
    }
    return Path()..addRect(_indicatorRectFor(rect, textDirection));
  }
}

class _UnderlinePainter extends BoxPainter {
  _UnderlinePainter(
    this.decoration,
    this.borderRadius,
    super.onChanged,
  );

  final UnderlineTabIndicator decoration;
  final BorderRadius? borderRadius;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Paint paint;
    if (borderRadius != null) {
      paint = Paint()..color = decoration.borderSide.color;
      final Rect indicator = decoration._indicatorRectFor(rect, textDirection);
      final RRect rrect = RRect.fromRectAndCorners(
        indicator,
        topLeft: borderRadius!.topLeft,
        topRight: borderRadius!.topRight,
        bottomRight: borderRadius!.bottomRight,
        bottomLeft: borderRadius!.bottomLeft,
      );
      canvas.drawRRect(rrect, paint);
    } else {
      paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
      final Rect indicator = decoration
          ._indicatorRectFor(rect, textDirection)
          .deflate(decoration.borderSide.width / 2.0);
      canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    }
  }
}
