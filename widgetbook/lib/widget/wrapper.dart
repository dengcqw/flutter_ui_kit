import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import '../knob/edgeinsets_knob.dart';

import 'package:ui_kit/widget/wrapper.dart';

@UseCase(
  name: 'Wrapper',
  type: Wrapper,
)
Widget buildWrapperUseCase(BuildContext context) {
  return Wrapper(
    spineHeight:
        context.knobs.double.input(label: 'spineHeight', initialValue: 8),
    angle: context.knobs.double.input(label: 'angle', initialValue: 75),
    radius: context.knobs.double.input(label: 'radius', initialValue: 5),
    offset: context.knobs.double.input(label: 'offset', initialValue: 15),
    strokeWidth: context.knobs.double.input(label: 'strokeWidth'),
    elevation: context.knobs.double.input(label: 'elevation'),
    shadowColor:
        context.knobs.color(initialValue: Colors.grey, label: 'shadowColor'),
    backgroundColr:
        context.knobs.color(initialValue: Colors.red, label: 'backgroundColr'),
    formEnd: context.knobs.boolean(label: 'formEnd'),
    strokeColor:
        context.knobs.color(initialValue: Colors.green, label: 'shadowColor'),
    padding: context.knobs
        .edgeInsetsAll(label: 'padding', initialValue: const EdgeInsets.all(8)),
    spineType: context.knobs.list(
      label: 'SpineType',
      initialOption: SpineType.left,
      options: [
        SpineType.left,
        SpineType.right,
        SpineType.bottom,
        SpineType.top
      ],
    ),
    //spinePathBuilder: null,
    child: const SizedBox(width: 100, height: 60),
  );
}
