import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class EdgeInsetsKnob extends Knob<EdgeInsets> {
  EdgeInsetsKnob({
    required super.label,
    required super.initialValue,
  });

  @override
  List<Field> get fields => [
        DoubleInputField(
          name: 'left',
          initialValue: initialValue.left,
        ),
        DoubleInputField(
          name: 'top',
          initialValue: initialValue.bottom,
        ),
        DoubleInputField(
          name: 'right',
          initialValue: initialValue.right,
        ),
        DoubleInputField(
          name: 'bottom',
          initialValue: initialValue.top,
        ),
      ];

  @override
  EdgeInsets valueFromQueryGroup(Map<String, String> group) {
    return EdgeInsets.fromLTRB(
      valueOf('left', group)!,
      valueOf('top', group)!,
      valueOf('right', group)!,
      valueOf('bottom', group)!,
    );
  }
}

extension EdgeInsetsKnobBuilder on KnobsBuilder {
  EdgeInsets edgeInsets({
    required String label,
    EdgeInsets initialValue = EdgeInsets.zero,
  }) =>
      onKnobAdded(
        EdgeInsetsKnob(
          label: label,
          initialValue: initialValue,
        ),
      )!;
}


class EdgeInsetsAllKnob extends Knob<EdgeInsets> {
  EdgeInsetsAllKnob({
    required super.label,
    required super.initialValue,
  });

  @override
  List<Field> get fields => [
        DoubleInputField(
          name: 'all',
          initialValue: initialValue.left,
        ),
   ];

  @override
  EdgeInsets valueFromQueryGroup(Map<String, String> group) {
    return EdgeInsets.fromLTRB(
      valueOf('all', group)!,
      valueOf('all', group)!,
      valueOf('all', group)!,
      valueOf('all', group)!,
    );
  }
}

extension EdgeInsetsAllKnobBuilder on KnobsBuilder {
  EdgeInsets edgeInsetsAll({
    required String label,
    EdgeInsets initialValue = EdgeInsets.zero,
  }) =>
      onKnobAdded(
        EdgeInsetsAllKnob(
          label: label,
          initialValue: initialValue,
        ),
      )!;
}
