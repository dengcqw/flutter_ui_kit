import 'package:flutter/material.dart';

class TipsButton extends StatelessWidget {
  const TipsButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
        child: const Icon(
          IconData(0xe729, fontFamily: 'myIcon', fontPackage: 'ui_kit'),
          color: Color(0xFF171921),
          size: 20.0,
        ),
      ),
    );
  }
}
