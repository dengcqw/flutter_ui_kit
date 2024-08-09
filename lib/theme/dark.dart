import 'package:flutter/widgets.dart';
import 'theme.dart';
import 'typography_theme_data.dart';

const darkTheme = AppThemeData(
  textStyle: TypographyThemeData(color: Color(0xFFEAE0D5)),
  color: ColorThemeData(
    pageBackground: Color(0xFF000000),
    text: TextColor(primary: Color(0xFFEAE0D5)),
  ),
);
