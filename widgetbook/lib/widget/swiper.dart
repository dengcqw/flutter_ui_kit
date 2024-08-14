import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

import 'package:ui_kit/widget/swiper.dart';

@UseCase(
  name: 'Swiper',
  type: Swiper,
)
Widget buildSwiperUseCase(BuildContext context) {
  return SizedBox(
    height: 200,
    child: Swiper.builder(
      childCount: context.knobs.int.input(label: 'childCount', initialValue: 4),
      itemBuilder: (context, index) {
        return Container(
          width: 100,
          height: 100,
          color: index.isEven ? Colors.orangeAccent : Colors.teal,
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        );
      },
      direction: context.knobs.list(
        label: 'direction',
        initialOption: Axis.horizontal,
        options: [
          Axis.horizontal,
          Axis.vertical,
        ],
      ),
      autoStart: context.knobs.boolean(label: 'autoStart', initialValue: true),
      indicator: CircleSwiperIndicator(
        itemColor: Colors.red,
        radius: 3,
        spacing: 10,
      ),
      speed: context.knobs.int.input(label: 'speed', initialValue: 300),
      interval: context.knobs.duration(
        label: 'interval',
        initialValue: const Duration(seconds: 3),
      ),
      circular: context.knobs.boolean(label: 'circular', initialValue: true),
      reverse: context.knobs.boolean(label: 'reverse'),
      indicatorAlignment: context.knobs.list(
        label: 'indicatorAlignment',
        initialOption: AlignmentDirectional.bottomCenter,
        options: [
          AlignmentDirectional.bottomCenter,
          AlignmentDirectional.bottomStart,
          AlignmentDirectional.bottomEnd,
        ],
      ),
      viewportFraction: context.knobs.double
          .input(label: 'viewportFraction', initialValue: 1),
    ),
  );
}
