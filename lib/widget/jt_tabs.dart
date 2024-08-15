import 'package:flutter/material.dart';
import 'dart:io' show Platform;

typedef TabSelectAction = Function(int selected);

enum SelectBorderStyle {
  round,rect;
}

///Tabs切换
///height 指定Tab的高度
///width非必填参数,宽度限制
/// '''
///   Flow布局使用
///   Expanded(
///            child: JTTabs(
///            height: 30,
///            names: ['日', '周', '月'],
///           ),
///   ),
///   or
///   Fixed布局使用
///   JTTabs(
///          width: 200,
///          height: 30,
///          names: ['日', '周', '月'],
///         )
///
/// names 必填，tab名称
/// selected 非必填 选择的callback
/// initIndex 非必填 初始化选中index
/// selectStyle 非必填 选中文本样式
/// normalStyle 非必填 未选中文本样式
/// borderColor 非必填 边框和选中填充颜色
class JTTabs extends StatefulWidget {
  final double space;
  final double height;
  final double? width;
  final bool wrapContent;
  final double? radius;
  final double borderWidth;
  final List<String> names;
  final TabSelectAction? selected;
  final int initIndex;
  final TextStyle selectStyle;
  final TextStyle normalStyle;
  final Color? borderColor;
  final Color? selectColor;
  final Color? normalColor;
  final Color? selectBorderColor;
  final Color? normalBorderColor;
  final Color? bgColor;
  final SelectBorderStyle selectBorderStyle;

  const JTTabs({
    required this.names,
    this.bgColor,
    Key? key,
    this.selectBorderStyle = SelectBorderStyle.rect,
    this.height = 30,
    this.initIndex = 0,
    this.space = 0,
    this.selected,
    this.width,
    this.radius,
    this.borderWidth = 1,
    this.wrapContent = false,
    this.borderColor = const Color(0xFFE4E4E4),
    this.selectColor = const Color(0xFFF7F8FA),
    this.selectBorderColor,
    this.normalColor,
    this.normalBorderColor,
    this.selectStyle = const TextStyle(
      color: Color(0xFFE6262C),
      fontSize: 12,
      fontWeight: FontWeight.normal
    ),
    this.normalStyle = const TextStyle(
      color: Color(0xFF61666D),
      fontSize: 12,
      fontWeight: FontWeight.normal
    ),
  })  : assert(names.length > 0),
        assert(initIndex < names.length),
        assert(height > 0),
        super(key: key);

  const JTTabs.middleRed({
    required this.names,
    this.bgColor,
    this.wrapContent = false,
    Key? key,
    this.selectBorderStyle = SelectBorderStyle.round,
    this.height = 30,
    this.initIndex = 0,
    this.space = 0,
    this.selected,
    this.width,
    this.radius,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFE4E4E4),
    this.selectColor = const Color.fromARGB(26, 230, 38, 44),
    this.selectBorderColor,
    this.normalColor,
    this.normalBorderColor,
    this.selectStyle = const TextStyle(
      color: Color(0xFFE6262C),
      fontSize: 12,
    ),
    this.normalStyle = const TextStyle(
      color: Color(0xFF999999),
      fontSize: 12,
    ),
  })  : assert(names.length > 0),
        assert(initIndex < names.length),
        assert(height > 0),
        super(key: key);


  const JTTabs.rectangle({
    required this.names,
    this.bgColor = const Color(0xFFEEEEEE),
    Key? key,
    this.selectBorderStyle = SelectBorderStyle.round,
    this.height = 30,
    this.initIndex = 0,
    this.wrapContent = false,
    this.space = 0,
    this.selected,
    this.width,
    this.radius = 5,
    this.borderWidth = 2,
    this.borderColor = const Color(0xFFEEEEEE),
    this.selectColor = Colors.white,
    this.selectBorderColor,
    this.normalColor,
    this.normalBorderColor,
    this.selectStyle = const TextStyle(
      color: Color(0xFFE6262C),
      fontSize: 12,
    ),
    this.normalStyle = const TextStyle(
      color: Color(0xFF999999),
      fontSize: 12,
    ),
  })  : assert(names.length > 0),
        assert(initIndex < names.length),
        assert(height > 0),
        super(key: key);

  const JTTabs.red({
    required this.names,
    this.wrapContent = false,
    this.bgColor,
    Key? key,
    this.selectBorderStyle = SelectBorderStyle.round,
    this.height = 30,
    this.initIndex = 0,
    this.space = 0,
    this.selected,
    this.width,
    this.radius,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFFE4E4E4),
    this.selectColor = const Color(0xFFE6262C),
    this.selectBorderColor,
    this.normalColor,
    this.normalBorderColor,
    this.selectStyle = const TextStyle(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    this.normalStyle = const TextStyle(
      color: Color(0xFFE6262C),
      fontSize: 12,
    ),
  })  : assert(names.length > 0),
        assert(initIndex < names.length),
        assert(height > 0),
        super(key: key);

  const JTTabs.spaceRed({
    required this.space,
    required this.names,
    this.wrapContent = false,
    Key? key,
    this.height = 30,
    this.initIndex = 0,
    this.selected,
    this.width,
    this.radius,
    this.borderWidth = 1,
    this.borderColor,
    this.selectColor,
    this.selectBorderStyle = SelectBorderStyle.round,
    this.selectBorderColor = const Color(0xFFE6262C),
    this.normalColor = const Color(0xFFF1F1F1),
    this.normalBorderColor,
    this.selectStyle = const TextStyle(
      color: Color(0xFFE6262C),
      fontSize: 12,
      fontWeight: FontWeight.w600
    ),
    this.normalStyle = const TextStyle(
      color: Color(0xFF3C3C3C),
      fontSize: 12,
    ),
    this.bgColor = Colors.white,
  })  : assert(names.length > 0),
        assert(initIndex < names.length),
        assert(height > 0),
        super(key: key);

  @override
  State<JTTabs> createState() => _JTTabsState();
}

class _JTTabsState extends State<JTTabs> {
  late int selectIndex;

  double get radiusValue {
    return widget.radius != null ? widget.radius! * 0.5 : widget.height * 0.5;
  }

  BorderRadius get radius {
    return BorderRadius.circular(radiusValue);
  }

  BorderRadius get leftRadius {
    final Radius radius = Radius.circular(radiusValue);
    return BorderRadius.only(topLeft: radius,bottomLeft: radius);
  }

  BorderRadius get rightRadius {
    final Radius radius = Radius.circular(radiusValue);
    return BorderRadius.only(topRight: radius,bottomRight: radius);
  }

  List<Widget> get tabs {
    if (widget.names.isEmpty) return [];
    List<Widget> tabs = [];
    for (int i = 0; i < widget.names.length; i++) {

      final BoxDecoration decoration = widget.selectBorderStyle == SelectBorderStyle.rect
          ? BoxDecoration(
              color: selectIndex == i ? widget.selectColor : widget.normalColor,
              borderRadius: selectIndex == i && i == 0 ? leftRadius : selectIndex == i && i == widget.names.length - 1 ? rightRadius : null,
            )
          : selectIndex == i
          ? BoxDecoration(
              color: widget.selectColor,
              borderRadius: radius,
              border: widget.selectBorderColor != null ? Border.all(color: widget.selectBorderColor!) : null,
          )
          : BoxDecoration(
              color: widget.normalColor,
              borderRadius: radius,
              border: widget.normalColor != null ? Border.all(color: widget.normalColor!) : null,
          );

      var paddingValue = widget.wrapContent ? 6.0 : 0.0;

      final tab = InkWell(
        onTap: () {
          onTap(i);
        },
        child: Container(
          alignment: Alignment.center,
          decoration: decoration,
          padding: EdgeInsets.only(left: paddingValue, right: paddingValue, bottom: Platform.isAndroid ? 2 : 0),
          child: Text(
            widget.names[i],
            style: selectIndex == i ? widget.selectStyle : widget.normalStyle,
            textAlign: TextAlign.center,
          ),
        ),
      );

      tabs.add(widget.wrapContent ? tab : Expanded(child: tab));

      if (widget.selectBorderStyle == SelectBorderStyle.rect && selectIndex == i) {
        if (i == 0) {
          tabs.add(Container(height: widget.height,width: 1,color: widget.borderColor,));
        } else if (i == widget.names.length - 1) {
          tabs.insert(tabs.length - 1, Container(height: widget.height,width: 1,color: widget.borderColor,));
        } else {
          tabs.insert(tabs.length - 1, Container(height: widget.height,width: 1,color: widget.borderColor,));
          tabs.add(Container(height: widget.height,width: 1,color: widget.borderColor,));
        }
      }

      if (widget.space > 0 && i < widget.names.length - 1) {
        final spaceBox = SizedBox(
          width: widget.space,
        );
        tabs.add(spaceBox);
      }
    }
    return tabs;
  }

  @override
  void initState() {
    selectIndex = widget.initIndex;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant JTTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initIndex != widget.initIndex) {
      setState(() {
        selectIndex = widget.initIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: widget.borderColor != null
          ? BoxDecoration(
              color: widget.bgColor ?? widget.normalColor,
              border: Border.all(color: widget.borderColor!, width: widget.borderWidth),
              borderRadius: radius)
          : BoxDecoration(
              color: widget.bgColor ?? widget.normalColor,
            ),
      child: Row(
        children: tabs,
      ),
    );
  }

  ///Actions
  void onTap(int index) {
    if (index == selectIndex) return;
    setState(() {
      selectIndex = index;
    });
    widget.selected?.call(index);
  }
}
