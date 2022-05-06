import 'package:dspatch_user/theme/colors.dart';
import 'package:flutter/material.dart';

//app theme
final ThemeData appTheme = ThemeData(
  fontFamily: 'ProductSans',
  scaffoldBackgroundColor: kMainColor,
  primaryColor: kMainColor,
  backgroundColor: kWhiteColor,
  disabledColor: kDisabledColor,
  buttonColor: kMainColor,
  cursorColor: kMainColor,
  indicatorColor: kMainColor,
  accentColor: kTransparentColor,
  hintColor: kHintColor,
  dividerColor: Color(0xffc2c2c2),
  primaryColorDark: kMainTextColor,
  hoverColor: kLightTextColor,
  cardColor: Color(0xffeaeaea),
  bottomAppBarTheme: BottomAppBarTheme(color: kMainColor),
  appBarTheme: AppBarTheme(
      color: kTransparentColor,
      elevation: 0.0,
      iconTheme: IconThemeData(color: kWhiteColor),
      centerTitle: true,
      textTheme: TextTheme(
              headline6: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
          .apply(displayColor: Colors.black, bodyColor: Colors.black)),

  //text theme which contains all text styles
  textTheme: TextTheme(
    //default text style of Text Widget
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
    subtitle1: TextStyle(color: kButtonTextColor),
    subtitle2: TextStyle(color: kWhiteColor, fontWeight: FontWeight.bold),
    headline3: TextStyle(),
    headline5: TextStyle(
        fontWeight: FontWeight.w500, color: kWhiteColor, fontSize: 22),
    headline6: TextStyle(color: kLightTextColor),
    caption: TextStyle(color: kMainTextColor),
    overline: TextStyle(),
    button: TextStyle(fontSize: 18, color: kWhiteColor),
  ),
);

final TextStyle listTitleTextStyle = TextStyle(
  fontSize: 16.7,
  fontWeight: FontWeight.bold,
  color: kMainColor,
  fontFamily: 'GoogleSans',
);

BoxShadow boxShadow = BoxShadow(
  color: kMainColor.withOpacity(0.3),
  blurRadius: 19.4, // soften the shadow
  spreadRadius: 1.2, //extend the shadow
  offset: Offset(
    0.0, // Move to right 10  horizontally
    10.3, // Move to bottom 10 Vertically
  ),
);

BorderRadius borderRadius = BorderRadius.only(topLeft: Radius.circular(35.0));

/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// body1        16.0  regular  0.5   (bodyText1)
/// body2        14.0  regular  0.25  (bodyText2)
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
