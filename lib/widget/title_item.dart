import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
//import 'package:ui_kit/color_style.dart';

class TitleItem extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final bool showMore;
  const TitleItem({
    required this.title,
    this.onTap,
    this.showMore = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleColor = AppTheme.of(context).color.text.primary;


    final text = Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: titleColor,
        fontWeight: FontWeight.w600,
      ),
    );

    if (showMore) {
      return InkWell(
        onTap: onTap,
        child: Row(
          children: [
            text,
            const SizedBox(
              width: 6,
            ),
            Image.asset(
              'images/icon_aright.png',
              package: 'assets',
              width: 15,
              height: 15,
              fit: BoxFit.fill,
            ),
          ],
        ),
      );
    } else {
      return Row(
        children: [text],
      );
    }
  }
}

class CardTitleContainer extends StatelessWidget {
  final Widget child;

  const CardTitleContainer({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderColor = AppTheme.of(context).color.divider;
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      child: child,
    );
  }
}
