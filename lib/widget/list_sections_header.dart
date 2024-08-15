import 'package:flutter/material.dart';
import 'package:ui_kit/utils/widgets.dart';
import 'package:ui_kit/utils/refresh.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:collection/collection.dart';
import 'dart:math';
import 'package:ui_kit/color_style.dart';
import 'package:ui_kit/widget/vertical_split.dart';
import 'package:ui_kit/widget/linked_scroll_controller.dart';
import 'package:flutter/gestures.dart';

// 带有排序剪头的标题
class _HeaderTitle extends StatelessWidget {
  final String title;
  final bool? sortUp; // 如果有值，会显示排序符号
  final void Function()? onSortTap;
  final TextAlign textAlign;
  const _HeaderTitle({
    required this.title,
    Key? key,
    this.sortUp,
    this.onSortTap,
    this.textAlign = TextAlign.end,
  }) : super(key: key);

  // 0 无状态，1升序 ，2 倒序
  int get sortType {
    if (sortUp == null) return 0;
    return sortUp! ? 1 : 2;
  }

  @override
  Widget build(BuildContext context) {
    var textWidget = Text(
      title,
      textAlign: textAlign,
      style: const TextStyle(
        color: Color(0xFF6E6E6E),
        fontSize: 11,
        height: 1.4,
      ),
    );
    return onSortTap == null
        ? textWidget
        : InkWell(
            onTap: onSortTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                textWidget,
                Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: CommonWidget.sortIcon(sortType, size: 4.0),
                ),
              ],
            ),
          );
  }
}

// 通过left 和 right 定位， 还可以排序
class ListHeaderTitle extends StatelessWidget {
  final String title;
  final double? left; // 相对容器左距离
  final double? right; // 相对容器右距离
  final bool? sortUp; // 如果有值，会显示排序符号
  final void Function()? onSortTap;
  const ListHeaderTitle({
    required this.title,
    Key? key,
    this.left,
    this.right,
    this.sortUp,
    this.onSortTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      child: _HeaderTitle(
        title: title,
        onSortTap: onSortTap,
        sortUp: sortUp,
      ),
    );
  }
}

// 列表顶部的header，设置好背景色和margin等样式
class ListSectionHeader extends StatelessWidget {
  final List<ListHeaderTitle> children;
  final double? height;
  const ListSectionHeader({
    required this.children,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 28,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: children,
      ),
    );
  }
}

// start of FlexList
enum TitleAligment { start, end, center }

class FlexListColumnConfig {
  final String title;
  final int flex;
  // 固定宽度
  final double? width;
  // true 升序，false 降序，null 没有排序
  final bool? sortUp;
  // 排序回调，如果有值，就会显示排序符号
  final void Function()? onSortTap;
  // 标题在可扩展的区间内的位置
  final TitleAligment alignment;

  /// 自动缩放，默认false
  final bool shrink;

  const FlexListColumnConfig({
    required this.title,
    Key? key,
    this.flex = 0,
    this.width,
    this.sortUp,
    this.onSortTap,
    this.shrink = false,
    this.alignment = TitleAligment.end,
  });

  static FlexListColumnConfig fixWidth(double width) {
    return FlexListColumnConfig(title: '', width: width);
  }
}

// depricated use FlexListColumnConfig
class FlexListHeaderTitle {
  final String title;
  final int flex;
  // 固定宽度
  final double? width;
  // true 升序，false 降序，null 没有排序
  final bool? sortUp;
  // 排序回调，如果有值，就会显示排序符号
  final void Function()? onSortTap;
  // 标题在可扩展的区间内的位置
  final TitleAligment alignment;

  const FlexListHeaderTitle({
    required this.title,
    Key? key,
    this.flex = 0,
    this.width,
    this.sortUp,
    this.onSortTap,
    this.alignment = TitleAligment.end,
  });

  FlexListHeaderTitle.fromConfig(FlexListColumnConfig config)
      : title = config.title,
        flex = config.flex,
        width = config.width,
        sortUp = config.sortUp,
        onSortTap = config.onSortTap,
        alignment = config.alignment;

  static FlexListHeaderTitle fixWidth(double width) {
    return FlexListHeaderTitle(title: '', width: width);
  }
}

// 定位组件: 支持flex或固定width
class FlexListCell extends StatelessWidget {
  final Widget child;
  final int flex;
  final double? width;
  final Color? color;
  // 标题在可扩展的区间内的位置
  final TitleAligment alignment;

  const FlexListCell({
    required this.child,
    Key? key,
    this.flex = 0,
    this.width,
    this.color,
    this.alignment = TitleAligment.end,
  }) : super(key: key);

  Alignment get containerAlign {
    switch (alignment) {
      case TitleAligment.start:
        return Alignment.centerLeft;
      case TitleAligment.end:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (width == null) {
      return Expanded(
        flex: flex,
        child: Container(
          color: color,
          alignment: containerAlign,
          child: child,
        ),
      );
    } else {
      return Container(
        color: color,
        alignment: containerAlign,
        width: width,
        child: child,
      );
    }
  }
}

class FlexListCellRow extends StatelessWidget {
  final List<FlexListColumnConfig> columnConfig;
  final List<Widget> children;
  final bool debug;
  final bool showDivider;
  final double? itemHeight;
  final EdgeInsets margin;

  final double? height;
  const FlexListCellRow({
    required this.columnConfig,
    required this.children,
    this.debug = false,
    this.showDivider = true,
    this.margin =
        const EdgeInsets.symmetric(horizontal: 17 /* 对齐标题padding 12 + 5*/),
    this.itemHeight,
    this.height,
    Key? key,
  }) : super(key: key);

  final topBorder = const BoxDecoration(
    border: Border(
      top: BorderSide(color: ColorStyle.borderColor1, width: 0.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    var rng = debug ? Random() : null;
    return Container(
      height: itemHeight,
      margin: margin,
      decoration: showDivider ? topBorder : null,
      child: Row(
        children: children.mapIndexed((index, widget) {
          return FlexListCell(
            color: rng != null
                ? Colors.lightGreen.withAlpha(rng.nextInt(255))
                : null,
            alignment: columnConfig[index].alignment,
            flex: columnConfig[index].flex,
            width: columnConfig[index].width,
            child: _ShrinkWrap(
              shrink: columnConfig[index].shrink,
              child: widget,
            ),
          );
        }).toList(),
      ),
    );
  }
}

// 列表顶部的header样式
class FlexListSectionHeaderContainer extends StatelessWidget {
  final Widget child;
  // 多行标题时，需要修改高度，默认28
  final double? height;
  const FlexListSectionHeaderContainer({
    required this.child,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 28,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}

// 列表顶部的header
class FlexListSectionHeaderRow extends StatelessWidget {
  final List<FlexListHeaderTitle> children;
  final bool debug;
  const FlexListSectionHeaderRow({
    required this.children,
    this.debug = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var rng = debug ? Random() : null;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children.map((element) {
        var titleWidget = element.title.isEmpty
            ? const SizedBox()
            : _HeaderTitle(
                title: element.title,
                onSortTap: element.onSortTap,
                sortUp: element.sortUp,
              );
        return FlexListCell(
          color: rng != null
              ? Colors.lightGreen.withAlpha(rng.nextInt(255))
              : null,
          alignment: element.alignment,
          flex: element.flex,
          width: element.width,
          child: titleWidget,
        );
      }).toList(),
    );
  }
}

// 列表顶部的header，设置好背景色和margin等样式, 按flex分配
class FlexListSectionHeader extends StatelessWidget {
  final List<FlexListHeaderTitle> children;
  final bool debug;
  final double? height;
  const FlexListSectionHeader({
    required this.children,
    this.debug = false,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexListSectionHeaderContainer(
      height: height,
      child: FlexListSectionHeaderRow(
        debug: debug,
        children: children,
      ),
    );
  }
}

// 圆角卡片
class CardContainer extends StatelessWidget {
  final Widget child;
  final bool useCardStyle;
  const CardContainer({
    required this.child,
    this.useCardStyle = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (useCardStyle) {
      return Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white,
        ),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: child,
      );
    }
    return child;
  }
}

class _InkWellWrap extends StatelessWidget {
  final void Function(int index)? onItemTap;
  final Widget child;
  final int index;
  const _InkWellWrap({
    required this.child,
    required this.index,
    this.onItemTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onItemTap != null) {
      return InkWell(
        onTap: () {
          onItemTap!(index);
        },
        child: child,
      );
    } else {
      return child;
    }
  }
}

class _ShrinkWrap extends StatelessWidget {
  final Widget child;
  final bool shrink;
  const _ShrinkWrap({
    required this.child,
    required this.shrink,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shrink
        ? FittedBox(
            fit: BoxFit.fill,
            child: child,
          )
        : child;
  }
}

class RefresherWrap extends StatelessWidget {
  final Widget child;

  final int itemCount;
  final void Function()? onRefresh;
  final void Function()? onLoading;
  final RefreshController? refreshCtrl;
  final ScrollController? scrollController;
  final bool disableScroll;

  const RefresherWrap({
    required this.child,
    this.refreshCtrl,
    this.scrollController,
    this.disableScroll = false,
    this.onRefresh,
    this.onLoading,
    this.itemCount = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (refreshCtrl == null) return child;

    var enablePullDown = onRefresh != null;
    var enablePullUp = onLoading != null;

    return SmartRefresher(
      physics: disableScroll ? const NeverScrollableScrollPhysics() : null,
      enablePullDown: enablePullDown,
      primary: false,
      enablePullUp: enablePullUp,
      controller: refreshCtrl!,
      scrollController: scrollController,
      header: enablePullDown ? Refresh.header() : null,
      footer: enablePullUp ? Refresh.footer(len: itemCount) : null,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: child,
    );
  }
}

typedef SectionListViewWidgetBuilder = List<Widget> Function(
    BuildContext context, int index);

/// 通过配置列的标题和列的组件快速组装成一个列表
/// 根据标题的配置进行各列的对齐
/// 支持排序功能，支持插入搜索框等固定头部widget
///
///  注意：column中使用此类，需要加Expanded
class SectionListView extends StatelessWidget {
  /// 标题栏配置和列布局配置
  final List<FlexListColumnConfig> columnConfig;

  /// 固定头部widget
  final Widget? header;

  /// 返回一行中各列组件，内部再进行对齐布局
  final SectionListViewWidgetBuilder itemBuilder;

  /// 数据的个数
  final int itemCount;

  /// 行的点击事件
  final void Function(int index)? onItemTap;

  /// 下拉刷新事件
  final void Function()? onRefresh;

  /// 上拉加载事件
  final void Function()? onLoading;

  /// 刷新的控制器
  final RefreshController? refreshCtrl;

  /// 圆角卡片 10pt margin 8pt raduis
  final bool useCardStyle;

  /// 分割线，默认有
  final bool showDivider;

  /// 标题栏可以滚动
  final bool titleScrollable;

  final bool shrinkWrap;

  final double? itemHeight;

  /// 标题栏高度，一般两行标题高度40
  final double? sectionHeaderHeight;

  /// 通过颜色调试布局
  final bool debug;

  const SectionListView({
    required this.columnConfig,
    required this.itemBuilder,
    required this.itemCount,
    this.refreshCtrl,
    this.debug = false,
    this.useCardStyle = true,
    this.showDivider = true,
    this.titleScrollable = false,
    this.shrinkWrap = false,
    this.onRefresh,
    this.itemHeight,
    this.sectionHeaderHeight,
    this.onLoading,
    this.onItemTap,
    this.header,
    Key? key,
  }) : super(key: key);

  Widget get titleHeader {
    return FlexListSectionHeader(
      height: sectionHeaderHeight,
      debug: debug,
      children: columnConfig
          .map((config) => FlexListHeaderTitle.fromConfig(config))
          .toList(),
    );
  }

  Widget get listWidget {
    if (itemCount == 0) {
      return Center(
        child: Refresh.nodata(),
      );
    }

    return ListView.builder(
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: shrinkWrap,
      itemCount: titleScrollable ? itemCount + 1 : itemCount,
      itemBuilder: (context, index) {
        if (index == 0 && titleScrollable) {
          return titleHeader;
        }
        var itemIndex = titleScrollable ? index - 1 : index;
        var items = itemBuilder(context, itemIndex);
        return _InkWellWrap(
          index: itemIndex,
          onItemTap: onItemTap,
          child: FlexListCellRow(
            itemHeight: itemHeight,
            showDivider: itemIndex != 0 && showDivider,
            debug: debug,
            columnConfig: columnConfig,
            children: items,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      useCardStyle: useCardStyle,
      child: Column(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        children: [
          header ?? const SizedBox(),
          if (!titleScrollable) titleHeader,
          shrinkWrap
              ? listWidget
              : Expanded(
                  child: RefresherWrap(
                    refreshCtrl: refreshCtrl,
                    onRefresh: onRefresh,
                    onLoading: onLoading,
                    itemCount: itemCount,
                    child: listWidget,
                  ),
                )
        ],
      ),
    );
  }
}

// start of VerticalSplitListView

// 列表顶部的header样式
class _VerticalSplitHeaderContainer extends StatelessWidget {
  final Widget child;
  // 多行标题时，需要修改高度，默认28
  final double? height;
  final bool leftHeader;
  const _VerticalSplitHeaderContainer({
    required this.child,
    required this.leftHeader,
    this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var margin = leftHeader
        ? const EdgeInsets.only(left: 12)
        : const EdgeInsets.only(right: 12);
    var padding = leftHeader
        ? const EdgeInsets.only(left: 5)
        : const EdgeInsets.only(right: 5);
    var borderRadius = leftHeader
        ? const BorderRadius.horizontal(left: Radius.circular(6))
        : const BorderRadius.horizontal(right: Radius.circular(6));

    return Container(
      height: height ?? 28,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class ExpandWrap extends StatelessWidget {
  final Widget child;
  final bool exp;

  const ExpandWrap({
    required this.child,
    required this.exp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (exp) {
      return Expanded(child: child);
    }
    return child;
  }
}

class VerticalSplitListView extends StatefulWidget {
  /// 标题栏配置和列布局配置, 也是不可滚动部分列
  final List<FlexListColumnConfig> columnConfig;

  /// 滚动部分的列布局配置
  final List<FlexListColumnConfig> scrollableColumnConfig;

  /// 固定头部widget
  final Widget? header;

  /// 返回一行中各列组件，内部再进行对齐布局
  final SectionListViewWidgetBuilder itemBuilder;

  /// 滚动部分组件，内部再进行对齐布局
  final SectionListViewWidgetBuilder scrollableItemBuilder;

  /// 数据的个数
  final int itemCount;

  /// 行的点击事件
  final ValueChanged<int>? onItemTap;

  /// 行的点击事件
  final bool Function(int)? willShowTopDivider;

  /// 下拉刷新事件
  final void Function()? onRefresh;

  /// 上拉加载事件
  final void Function()? onLoading;

  /// 刷新的控制器
  final RefreshController? refreshCtrl;

  /// 分割线，默认有
  final bool showDivider;

  final bool shrinkWrap;

  /// 标题栏可以滚动
  final bool titleScrollable;

  final double? itemHeight;

  /// 通过颜色调试布局
  final bool debug;

  const VerticalSplitListView({
    required this.columnConfig,
    required this.itemBuilder,
    required this.itemCount,
    required this.scrollableColumnConfig,
    required this.scrollableItemBuilder,
    this.refreshCtrl,
    this.debug = false,
    this.showDivider = true,
    this.willShowTopDivider,
    this.shrinkWrap = false,
    this.onRefresh,
    this.titleScrollable = false,
    this.itemHeight,
    this.onLoading,
    this.onItemTap,
    this.header,
    Key? key,
  }) : super(key: key);

  @override
  VerticalSplitListViewState createState() => VerticalSplitListViewState();
}

class VerticalSplitListViewState extends State<VerticalSplitListView> {
  final _controllers = LinkedScrollControllerGroup();
  final _controllersH = LinkedScrollControllerGroup();
  late ScrollController _controller1;
  late ScrollController _controller2;
  late ScrollController _controller1H;
  late ScrollController _controller2H;

  Drag? drag;
  double startPanY = 0;

  /// 内部列表的当前滑动位置
  double startOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller1 = _controllers.addAndGet();
    _controller2 = _controllers.addAndGet();
    _controller1H = _controllersH.addAndGet();
    _controller2H = _controllersH.addAndGet();
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller1H.dispose();
    _controller2H.dispose();
    super.dispose();
  }

  Widget titleHeader(List<FlexListColumnConfig> configs, bool isLeft) {
    return _VerticalSplitHeaderContainer(
      leftHeader: isLeft,
      child: FlexListSectionHeaderRow(
        debug: widget.debug,
        children: configs
            .map((config) => FlexListHeaderTitle.fromConfig(config))
            .toList(),
      ),
    );
  }

  Widget listWidget(List<FlexListColumnConfig> config,
      SectionListViewWidgetBuilder builder, bool isLeft) {
    var margin = isLeft
        ? const EdgeInsets.only(left: 17)
        : const EdgeInsets.only(right: 17);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: widget.shrinkWrap,
      controller: isLeft ? _controller1 : _controller2,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        print('---->index: ${index.toString()}');
        var items = builder(context, index);
        var showTopDivider =  widget.willShowTopDivider != null ? widget.willShowTopDivider!(index) : widget.showDivider;
        return _InkWellWrap(
          index: index,
          onItemTap: widget.onItemTap,
          child: FlexListCellRow(
            margin: margin,
            itemHeight: widget.itemHeight,
            showDivider: index != 0 && showTopDivider,
            debug: widget.debug,
            columnConfig: config,
            children: items,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var widthLeft = widget.columnConfig
            .map((e) => e.width!)
            .reduce((value, element) => value + element) +
        17;

    var widthRight = widget.scrollableColumnConfig.isNotEmpty
        ? widget.scrollableColumnConfig
                .map((e) => e.width!)
                .reduce((value, element) => value + element) +
            17
        : 0.0;

    return LayoutBuilder(builder: ((context, constraints) {
      // print('---->constraints: ${constraints.toString()}');
      return GestureDetector(
        onPanEnd: (detail) {
          //var info =
          //'onPanEnd:\n初速度:${detail.primaryVelocity}\n最终速度:${detail.velocity}';
          //print(info);

          var dy = detail.velocity.pixelsPerSecond.dy;
          if (drag != null) {
            final DragEndDetails verticalDragDetails = DragEndDetails(
              velocity: Velocity(pixelsPerSecond: Offset(0.0, dy)),
              primaryVelocity: dy,
            );
            drag?.end(verticalDragDetails);
            drag = null;
          } else {
            _controller1.animateTo(_controller1.offset - dy * 0.5,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500));
          }

          startPanY = 0;
        },
        onPanUpdate: (detail) {
          //var info =
          //'onPanUpdate:\n相对落点:${detail.localPosition}\n绝对落点:${detail.globalPosition}';
          //print(info);

          var y = detail.localPosition.dy;
          var newScrollOffset = startOffset + startPanY - y;
          if (newScrollOffset < _controller1.position.maxScrollExtent &&
              newScrollOffset > _controller1.position.minScrollExtent) {
            //print('---->new scroll Offset: ${newScrollOffset.toString()}');
            _controller1.jumpTo(newScrollOffset);
          } else {
            var dragdown = false;
            var dragup = false;
            // 在顶部下拉
            if (newScrollOffset < _controller1.position.minScrollExtent) {
              var offset =
                  newScrollOffset - _controller1.position.minScrollExtent;
              print('---->drag down offset: ${offset.toString()}');
              if (offset <= 0) {
                dragdown = true;
              }
            } else {
              // 在底部上拉
              var offset =
                  newScrollOffset - _controller1.position.maxScrollExtent;
              print('---->drag up offset: ${offset.toString()}');
              if (offset >= 0) {
                dragup = true;
              }
            }

            // 传递事件到刷新组件
            if (dragdown || dragup) {
              var pos = widget.refreshCtrl?.position;
              if (pos == null) return;
              if (drag != null) {
                drag?.update(newFromStartOffset(detail));
                return;
              }
              var startDetail = startFromUpdate(detail);
              drag = pos.drag(startDetail, () => print('onDragCanceled'));
            }
          }
        },
        onPanStart: (detail) {
          //var info =
          //'onPanStart:\n相对落点:${detail.localPosition}\n绝对落点:${detail.globalPosition}';
          //print(info);
          startPanY = detail.localPosition.dy;
          startOffset = _controller1.offset;
          drag = null;
          print('---->startOffset: ${startOffset.toString()}');
        },
        onPanCancel: () {
          drag?.cancel();
          drag = null;
        },
        child: Column(
          children: [
            const SizedBox(height: 10),
            // header
            MultipleVerticalSplitShadow(
              splitLineConfig: [
                SplitLineConfig(
                  left: widget.itemCount == 0 ? -30 : widthLeft,
                ),
                SplitLineConfig(
                  right: widget.itemCount == 0 ? -30 : 0,
                  startColor: Colors.white.withAlpha(0),
                  endColor: Colors.white,
                ),
              ],
              child: Row(
                children: [
                  // header left
                  SizedBox(
                    width: widthLeft,
                    child: titleHeader(widget.columnConfig, true),
                  ),
                  // scrollable header right
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _controller1H,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: widthRight,
                        child:
                            titleHeader(widget.scrollableColumnConfig, false),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // listview
            if (widget.itemCount != 0 && !widget.shrinkWrap)
              Expanded(
                child: RefresherWrap(
                  disableScroll: true,
                  itemCount: widget.itemCount,
                  onLoading: widget.onLoading,
                  refreshCtrl: widget.refreshCtrl,
                  onRefresh: widget.onRefresh,
                  // support refresh widget
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      height: constraints.maxHeight - 38,
                      child: listBody(widthLeft, widthRight),
                    ),
                  ),
                ),
              ),
            if (widget.itemCount != 0 && widget.shrinkWrap)
              listBody(widthLeft, widthRight),
            if (widget.itemCount == 0)
              Expanded(
                child: Center(
                  child: Refresh.nodata(),
                ),
              )
          ],
        ),
      );
    }));
  }

  Widget listBody(double widthLeft, double widthRight) {
    return MultipleVerticalSplitShadow(
      splitLineConfig: [
        SplitLineConfig(
          left: widget.itemCount == 0 ? -30 : widthLeft,
        ),
        SplitLineConfig(
          right: widget.itemCount == 0 ? -30 : 0,
          startColor: Colors.white.withAlpha(0),
          endColor: Colors.white,
        ),
      ],
      child: Row(
        children: [
          // listview left
          SizedBox(
            width: widthLeft,
            child: listWidget(widget.columnConfig, widget.itemBuilder, true),
          ),
          // scrollable listview right
          Expanded(
            child: SingleChildScrollView(
              controller: _controller2H,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: widthRight,
                child: listWidget(widget.scrollableColumnConfig,
                    widget.scrollableItemBuilder, false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* demo
   Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: VerticalSplitListView(
          debug: false,
          columnConfig: const [
            FlexListColumnConfig(title: 'Fixed1', width: 40, alignment: TitleAligment.start),
            FlexListColumnConfig(title: 'Fixed2', width: 80, alignment: TitleAligment.start),
          ],
          scrollableColumnConfig: const [
            FlexListColumnConfig(title: 'scoll1', width: 40),
            FlexListColumnConfig(title: 'scoll2', width: 40),
            FlexListColumnConfig(title: 'scoll3', width: 40),
            FlexListColumnConfig(title: 'scoll3', width: 40),
            FlexListColumnConfig(title: 'scoll3', width: 40),
            FlexListColumnConfig(title: 'scoll3', width: 40),
            FlexListColumnConfig(title: 'scoll3', width: 40),
          ],
          itemBuilder: (context, index) {
            var style = const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            );
            return [
              Text('$index', style: style),
              Text('fixed$index', style: style),
            ];
          },
          scrollableItemBuilder: (context, index) {
            var style = const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            );
            return [
              Text('$index', style: style),
              Text('$index', style: style),
              Text('$index', style: style),
              Text('$index', style: style),
              Text('$index', style: style),
              Text('$index', style: style),
              Text('$index', style: style),
            ];
          },
          itemCount: 40,
          itemHeight: 50,
        )
      )
   */

DragStartDetails startFromUpdate(DragUpdateDetails details) {
  return DragStartDetails(
      globalPosition: details.globalPosition,
      localPosition: details.localPosition,
      sourceTimeStamp: details.sourceTimeStamp,
      kind: PointerDeviceKind.touch);
}

DragUpdateDetails newFromStartOffset(DragUpdateDetails details) {
  return DragUpdateDetails(
    sourceTimeStamp: details.sourceTimeStamp,
    delta: Offset(0.0, details.delta.dy),
    primaryDelta: details.delta.dy,
    globalPosition: details.globalPosition,
    localPosition: details.localPosition,
  );
}

