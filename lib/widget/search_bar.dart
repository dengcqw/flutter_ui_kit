import 'package:flutter/material.dart';
import 'package:ui_kit/theme/app_theme.dart';
//import 'package:ui_kit/generated/l10n.dart';

class JTSearchBar extends StatefulWidget {

  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TapRegionCallback? onTapOutside;
  final GestureTapCallback? onTap;
  final String? hintText;
  const JTSearchBar({super.key, this.focusNode, this.controller, this.onChanged, this.onTapOutside, this.onTap, this.hintText});

  @override
  State<JTSearchBar> createState() => _JTSearchBarState();
}

class _JTSearchBarState extends State<JTSearchBar> {
  @override
  Widget build(BuildContext context) {

    final theme = AppTheme.of(context);
    final hintColor = theme.color.text.info;
    final borderColor = theme.color.divider;

    return TextField(
      onTap: widget.onTap,
      onTapOutside: widget.onTapOutside,
      cursorColor: Colors.red,
      onChanged: (text) {
        widget.onChanged?.call(text);
        setState(() {});
      },
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: TextInputType.text,
      style: const TextStyle(fontSize: 14, color: Color(0xFF3C3C3C)),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19.0),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(19),
          ),
          borderSide: BorderSide(
            color: Color(0xFFF5F6F9),
            width: 1,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFF5F6F9),
            width: 1,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(19),
          ),
        ),
        fillColor: Color(0xFFF5F6F9),
        filled: true,
        hintText: widget.hintText, //?? S.of(context).crm_enter_content_to_query,//'请输入要查询的内容',
        hintStyle: TextStyle(color: hintColor, fontSize: 14),
        prefix: Padding(
          padding: EdgeInsets.only(left: 13.0,right: 10),
          child: Icon(
            IconData(
              0xe70b,
              fontFamily: 'myIcon',
            ),
            color: hintColor,
            size: 15,
          ),
        ),
        suffix: Padding(
          padding: const EdgeInsets.only(left: 10.0,right: 13),
          child: widget.controller?.text == null || widget.controller!.text.isEmpty
              ? const SizedBox()
              : InkWell(
            onTap: (){
              widget.controller?.clear();
              widget.onChanged?.call('');
              setState(() {});
            },
            child: Icon(
              IconData(0xe70c, fontFamily: 'myIcon',),
              color: hintColor,
              size: 15,
            ),
          ),
        ),
        contentPadding: EdgeInsets.zero,
      ),
      autofocus: false,
    );
  }
}
