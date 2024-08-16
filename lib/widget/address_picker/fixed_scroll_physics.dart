
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'dart:math' as math;

class FixedScrollPhysics extends ScrollPhysics {
  final double itemExtent;

  /// Creates a scroll physics that always lands on items.
  const FixedScrollPhysics(this.itemExtent, {ScrollPhysics? parent})
      : super(parent: parent);

  @override
  FixedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return FixedScrollPhysics(itemExtent, parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final metrics = position;

    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's boundary.
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final Simulation? testFrictionSimulation =
        super.createBallisticSimulation(metrics, velocity);

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null &&
        (testFrictionSimulation.x(double.infinity) == metrics.minScrollExtent ||
            testFrictionSimulation.x(double.infinity) ==
                metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final int settlingItemIndex = _getItemFromOffset(
      offset: testFrictionSimulation?.x(double.infinity) ?? metrics.pixels,
      itemExtent: itemExtent,
      minScrollExtent: metrics.minScrollExtent,
      maxScrollExtent: metrics.maxScrollExtent,
    );

    final double settlingPixels = settlingItemIndex * itemExtent;

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    // ignore: deprecated_member_use
    if (velocity.abs() < tolerance.velocity &&
        // ignore: deprecated_member_use
        (settlingPixels - metrics.pixels).abs() < tolerance.distance) {
      return null;
    }

    // Scenario 4:
    //If we're going to end back at the same item because initial velocity
    //is too low to break past it, use a spring simulation to get back.
    if (settlingItemIndex ==
        _getItemFromOffset(
          offset: metrics.pixels,
          itemExtent: itemExtent,
          minScrollExtent: metrics.minScrollExtent,
          maxScrollExtent: metrics.maxScrollExtent,
        )) {
      return SpringSimulation(
        spring,
        metrics.pixels,
        settlingPixels,
        velocity,
        // ignore: deprecated_member_use
        tolerance: tolerance,
      );
    }
    // Scenario 5:
    // Create a new friction simulation except the drag will be tweaked to land
    // exactly on the item closest to the natural stopping point.
    return FrictionSimulation.through(
      metrics.pixels,
      settlingPixels,
      velocity,
      // ignore: deprecated_member_use
      tolerance.velocity * velocity.sign,
    );
  }
}

class FixedScrollController extends ScrollController {
  final int initialItem;

  FixedScrollController({
    this.initialItem = 0,
  });

  int get selectedItem {
    if (positions.isEmpty) return initialItem;

    final physics = position.physics as FixedScrollPhysics;
    return _getItemFromOffset(
      offset: position.pixels,
      itemExtent: physics.itemExtent,
      minScrollExtent: position.minScrollExtent,
      maxScrollExtent: position.maxScrollExtent,
    );
  }

  Future<void> animateToItem(
    int itemIndex, {
    required Duration duration,
    required Curve curve,
  }) async {
    if (!hasClients) {
      return;
    }

    await Future.wait<void>(<Future<void>>[
      for (final position in positions)
        position.animateTo(
          itemIndex * (position.physics as FixedScrollPhysics).itemExtent,
          duration: duration,
          curve: curve,
        ),
    ]);
  }

  Future<void> jumpToItem(
    int itemIndex) async {
    if (!hasClients) {
      return;
    }
    for (final position in positions) {
      position.jumpTo(
        itemIndex * (position.physics as FixedScrollPhysics).itemExtent,
      );
    }

  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition? oldPosition) {
    return _FixedScrollPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      oldPosition: oldPosition,
    );
  }
}


class _FixedScrollPosition extends ScrollPositionWithSingleContext implements FixedExtentMetrics {
  _FixedScrollPosition({
    required ScrollPhysics physics,
    required ScrollContext context,
    required int initialItem,
    bool keepScrollOffset = true,
    ScrollPosition? oldPosition,
    String? debugLabel,
  }):
        super(
        physics: physics,
        context: context,
        initialPixels: _getItemExtentFromScrollContext(physics) * initialItem,
        keepScrollOffset: keepScrollOffset,
        oldPosition: oldPosition,
        debugLabel: debugLabel,
      );

  static double _getItemExtentFromScrollContext(ScrollPhysics physics) {
    return (physics as FixedScrollPhysics).itemExtent;
  }

  double get itemExtent => _getItemExtentFromScrollContext(physics);

  @override
  int get itemIndex {
    return _getItemFromOffset(
      offset: pixels,
      itemExtent: itemExtent,
      minScrollExtent: minScrollExtent,
      maxScrollExtent: maxScrollExtent,
    );
  }

  @override
  FixedExtentMetrics copyWith({
    double? minScrollExtent,
    double? maxScrollExtent,
    double? pixels,
    double? viewportDimension,
    AxisDirection? axisDirection,
    int? itemIndex,
    double? devicePixelRatio,
  }) {
    return FixedExtentMetrics(
      minScrollExtent: minScrollExtent ?? (hasContentDimensions ? this.minScrollExtent : null),
      maxScrollExtent: maxScrollExtent ?? (hasContentDimensions ? this.maxScrollExtent : null),
      pixels: pixels ?? (hasPixels ? this.pixels : null),
      viewportDimension: viewportDimension ?? (hasViewportDimension ? this.viewportDimension : null),
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }
}

int _getItemFromOffset({
  required double offset,
  required double itemExtent,
  required double minScrollExtent,
  required double maxScrollExtent,
}) {
  return (_clipOffsetToScrollableRange(offset, minScrollExtent, maxScrollExtent) / itemExtent).round();
}

double _clipOffsetToScrollableRange(
  double offset,
  double minScrollExtent,
  double maxScrollExtent,
) {
  return math.min(math.max(offset, minScrollExtent), maxScrollExtent);
}
