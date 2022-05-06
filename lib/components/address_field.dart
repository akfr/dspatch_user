import 'package:flutter/material.dart';

class AddressField extends StatelessWidget {
  final String initialValue;
  final Widget icon;
  final BorderSide border;
  final Color color;
  final Widget suffix;
  final String hint;
  final Function onTap;
  final bool readOnly;
  final TextEditingController controller;
  final Function(String) onSubmitted, onChanged;
  final BorderRadius borderRadius;
  final TextStyle style, hintStyle;
  final TextInputType keyBoardType;
  final int maxLength;

  AddressField(
      {this.initialValue,
      this.icon,
      this.border,
      this.color,
      this.suffix,
      this.hint,
      this.onTap,
      this.readOnly,
      this.controller,
      this.onSubmitted,
      this.onChanged,
      this.borderRadius,
      this.style,
      this.hintStyle,
      this.keyBoardType,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return TextFormField(
      maxLength: maxLength,
      keyboardType: keyBoardType,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      controller: controller,
      style: style ?? TextStyle(color: theme.primaryColorDark),
      initialValue: initialValue,
      readOnly: readOnly ?? false,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hint ?? '',
        hintStyle: hintStyle,
        suffixIcon: suffix /*?? SizedBox.shrink()*/,
        border: OutlineInputBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(35.0),
            borderSide: border ?? BorderSide.none),
        counter: Offstage(),
        fillColor: color ?? theme.backgroundColor,
        filled: true,
      ),
    );
  }
}
