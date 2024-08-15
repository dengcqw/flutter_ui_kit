import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import '../knob/text_style_knob.dart';

import 'package:ui_kit/widget/digit_label.dart';

@UseCase(
  name: 'DigitLabel',
  type: DigitLabel,
)
Widget buildDigitLabelUseCase(BuildContext context) {
  return ColoredBox(
    color: Colors.white,
    child: DigitLabel(
      value: context.knobs.double.input(label: 'value'),
      textStyle: context.knobs.textStyle(
        label: 'textStyle',
        initialValue: TextStyle(
          color: Colors.red,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      fractionDigits:
          context.knobs.int.input(label: 'fractionDigits', initialValue: 1),
      fractionFontSize: context.knobs.double
          .input(label: 'fractionFontSize', initialValue: 8),
      prefixSymbol:
          context.knobs.string(label: 'prefixSymbol', initialValue: '\$'),
      suffixSymbol:
          context.knobs.string(label: 'suffixSymbol', initialValue: '%'),
      prefixSymbolFontSize: context.knobs.double
          .input(label: 'prefixSymbolFontSize', initialValue: 10),
      suffixSymbolFontSize: context.knobs.double
          .input(label: 'suffixSymbolFontSize', initialValue: 10),
      height: context.knobs.double.input(label: 'height', initialValue: 50),
      alignment: context.knobs.list(
        label: 'alignment',
        initialOption: Alignment.centerLeft,
        options: [
          Alignment.centerLeft,
          Alignment.center,
          Alignment.centerRight,
        ],
      ),
    ),
  );
}
