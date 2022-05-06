import 'package:dspatch_user/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomSearchBar extends StatelessWidget {
  final String hint;
  final Function onTap;
  final Color color;
  final BoxShadow boxShadow;
  final Icon icon;

  CustomSearchBar(
      {this.hint, this.onTap, this.color, this.boxShadow, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: kMainColor.withOpacity(0.3),
            blurRadius: 19.4, // soften the shadow
            spreadRadius: 1.2, //extend the shadow
            offset: Offset(
              0.0, // Move to right 10  horizontally
              10.3, // Move to bottom 10 Vertically
            ),
          )
        ],
        borderRadius: BorderRadius.circular(30.0),
        color: color ?? kWhiteColor,
      ),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: kMainColor,
        decoration: InputDecoration(
          icon: icon,
          hintText: hint,
          hintStyle:
              Theme.of(context).textTheme.subtitle2.copyWith(color: kHintColor),
          border: InputBorder.none,
        ),
        onTap: onTap,
      ),
    );
  }
}
