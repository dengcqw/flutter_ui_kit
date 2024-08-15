import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class TextStyleKnob extends Knob<TextStyle> {
  TextStyleKnob({
    required super.label,
    required super.initialValue,
  });

  @override
  List<Field> get fields => [
        ListField<FontWeight>(
          name: 'fontWeight',
          values: [
            FontWeight.normal,
            FontWeight.w600,
            FontWeight.bold,
          ],
          initialValue: initialValue.fontWeight,
        ),
        DoubleInputField(
          name: 'fontSize',
          initialValue: initialValue.fontSize,
        ),
        ColorField(
          name: 'color',
          initialValue: initialValue.color,
        ),
      ];

  @override
  TextStyle valueFromQueryGroup(Map<String, String> group) {
    final size = valueOf('fontSize', group);
    return TextStyle(
      fontWeight: valueOf('fontWeight', group),
      fontSize: size < 5 ? 5.0 : size ,
      color: valueOf('color', group),
    );
  }
}

extension EdgeInsetsKnobBuilder on KnobsBuilder {
  TextStyle textStyle({
    required String label,
    TextStyle initialValue = const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.normal),
  }) =>
      onKnobAdded(
        TextStyleKnob(
          label: label,
          initialValue: initialValue,
        ),
      )!;
}

