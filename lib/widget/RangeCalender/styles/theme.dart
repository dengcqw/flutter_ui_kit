import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'badge_theme.dart';
import 'button_theme.dart';
import 'loading_theme.dart';
import 'toast_theme.dart';

class FlanTheme extends StatelessWidget {
  const FlanTheme({
    required this.data, required this.child, Key? key,
  }) : super(key: key);

  final FlanThemeData data;

  final Widget child;

  static double Function(num n) rpx = (num n) => n.toDouble();

  static final FlanThemeData _kFallbackTheme = FlanThemeData.fallback();

  static FlanThemeData of(BuildContext context) {
    final _InheritedFlanTheme? inheritedTheme =
    context.dependOnInheritedWidgetOfExactType<_InheritedFlanTheme>();

    return inheritedTheme?.theme.data ?? _kFallbackTheme;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFlanTheme(
      theme: this,
      child: child,
    );
  }
}

class _InheritedFlanTheme extends InheritedTheme {
  const _InheritedFlanTheme({
    required this.theme, required Widget child, Key? key,
  }) : super(key: key, child: child);

  final FlanTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return FlanTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedFlanTheme old) =>
      theme.data != old.theme.data;
}

@immutable
class FlanThemeData with Diagnosticable {
  factory FlanThemeData({
    Color? overlayBackgroundColor,
    FlanBadgeThemeData? badgeTheme,
    FlanButtonThemeData? buttonTheme,
    FlanToastThemeData? toastTheme,
    FlanLoadingThemeData? loadingTheme,
  }) {
    return FlanThemeData.raw(
      overlayBackgroundColor:
      overlayBackgroundColor ?? const Color.fromRGBO(0, 0, 0, .7),
      badgeTheme: badgeTheme ?? FlanBadgeThemeData(),
      buttonTheme: buttonTheme ?? FlanButtonThemeData(),
      loadingTheme: loadingTheme ?? FlanLoadingThemeData(),
      toastTheme: toastTheme ?? FlanToastThemeData(),
    );
  }

  const FlanThemeData.raw({
    required this.overlayBackgroundColor,
    required this.badgeTheme,
    required this.buttonTheme,
    required this.toastTheme,
    required this.loadingTheme,
  });

  factory FlanThemeData.fallback() => FlanThemeData();

  final Color overlayBackgroundColor;


  /// Badge 徽标
  final FlanBadgeThemeData badgeTheme;

  /// Button 按钮
  final FlanButtonThemeData buttonTheme;

  /// Loading 加载
  final FlanLoadingThemeData loadingTheme;

  /// Toast 轻提示
  final FlanToastThemeData toastTheme;

  static FlanThemeData lerp(FlanThemeData a, FlanThemeData b, double t) {
    return FlanThemeData.raw(
      overlayBackgroundColor:
      Color.lerp(a.overlayBackgroundColor, b.overlayBackgroundColor, t)!,
      badgeTheme: FlanBadgeThemeData.lerp(a.badgeTheme, b.badgeTheme, t),
      buttonTheme: FlanButtonThemeData.lerp(a.buttonTheme, b.buttonTheme, t),
      toastTheme: FlanToastThemeData.lerp(a.toastTheme, b.toastTheme, t),
      loadingTheme:
      FlanLoadingThemeData.lerp(a.loadingTheme, b.loadingTheme, t),
    );
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[];
    return Object.hashAll(values);
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is FlanThemeData && other.buttonTheme == buttonTheme;
  }
}

class FlanThemeDataTween extends Tween<FlanThemeData> {
  FlanThemeDataTween({FlanThemeData? begin, FlanThemeData? end})
      : super(begin: begin, end: end);

  @override
  FlanThemeData lerp(double t) => FlanThemeData.lerp(begin!, end!, t);
}

class FlanAnimatedTheme extends ImplicitlyAnimatedWidget {
  const FlanAnimatedTheme({
    required this.data, required this.child, Key? key,
    Curve curve = Curves.linear,
    Duration duration = kThemeAnimationDuration,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  final FlanThemeData data;

  final Widget child;

  @override
  AnimatedThemeState createState() => AnimatedThemeState();
}

class AnimatedThemeState extends AnimatedWidgetBaseState<AnimatedTheme> {
  FlanThemeDataTween? _data;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _data = visitor(
        _data,
        widget.data,
            (dynamic value) =>
            FlanThemeDataTween(begin: value as FlanThemeData))!
    as FlanThemeDataTween;
  }

  @override
  Widget build(BuildContext context) {
    return FlanTheme(
      data: _data!.evaluate(animation),
      child: widget.child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<FlanThemeDataTween>('data', _data,
        showName: false, defaultValue: null));
  }
}
