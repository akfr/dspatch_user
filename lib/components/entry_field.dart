import 'package:dspatch_user/theme/colors.dart';
import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String image;
  final String initialValue;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLength;
  final int maxLines;
  final String hint;
  final IconData suffixIcon;
  final Function onTap;
  final TextCapitalization textCapitalization;
  final Function onSuffixPressed;
  final Widget prefix;
  final bool obscureText;

  EntryField(
      {this.controller,
      this.label,
      this.image,
      this.initialValue,
      this.readOnly,
      this.keyboardType,
      this.maxLength,
      this.hint,
      this.suffixIcon,
      this.maxLines,
      this.onTap,
      this.textCapitalization,
      this.onSuffixPressed,
      this.prefix,
      this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            label ?? '',
            style: Theme.of(context).textTheme.headline5.copyWith(
                color: Theme.of(context).primaryColorDark, fontSize: 22),
          ),
          TextFormField(
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 18),
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
            cursorColor: kMainColor,
            autofocus: false,
            onTap: onTap ?? null,
            controller: controller,
            readOnly: readOnly ?? false,
            keyboardType: keyboardType,
            minLines: 1,
            initialValue: initialValue,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            obscureText: obscureText ?? false,
            decoration: InputDecoration(
                prefix: prefix,
                suffixIcon: IconButton(
                  icon: Icon(
                    suffixIcon,
                    size: 40.0,
                    color: kMainColor,
                  ),
                  onPressed: onSuffixPressed ?? null,
                ),
                hintText: hint,
                hintStyle: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(fontSize: 18),
                counter: Offstage(),
                focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor))),
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
