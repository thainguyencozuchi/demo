// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static const Color mainColors = Color.fromARGB(255, 174, 233, 254);
  static const Color notWhite = Color(0xFFEDF0F2);
  static const Color nearlyWhite = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFFFFFFF);
  static const Color nearlyBlack = Color(0xFF213333);
  static const Color grey = Color(0xFF3A5160);
  static const Color dark_grey = Color(0xFF313A44);
  static const Color blue = Color.fromARGB(255, 0, 67, 143);

  static const Color darkText = Color(0xFF253840);
  static const Color darkerText = Color(0xFF17262A);
  static const Color lightText = Color(0xFF4A6572);
  static const Color deactivatedText = Color(0xFF767676);
  static const Color dismissibleBackground = Color(0xFF364A54);
  static const Color chipBackground = Color(0xFFEEF1F3);
  static const Color spacer = Color(0xFFF2F2F2);
  static const String fontName = 'WorkSans';

  static const Color blue1 = Color.fromARGB(255, 102, 173, 255);
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color orange = Colors.orange;

  static const TextTheme textTheme = TextTheme(
    headline4: display1,
    headline5: headline,
    headline6: title,
    subtitle2: subtitle,
    bodyText2: body2,
    bodyText1: body1,
    caption: caption,
  );

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    letterSpacing: 0.27,
    color: darkerText,
  );

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: -0.04,
    color: darkText,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.2,
    color: darkText,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontFamily: fontName,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: -0.05,
    color: darkText,
  );

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );

  static const TextStyle nameUerPosts = TextStyle(color: lightText, fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.bold);

  static const TextStyle timePosts = TextStyle(color: lightText, fontSize: 13, letterSpacing: 1, fontWeight: FontWeight.normal);

  static const TextStyle titlePost = TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.normal);

  static const TextStyle textButtonWhite = TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 14, letterSpacing: 1, fontWeight: FontWeight.normal);

  static const TextStyle lableInput = TextStyle(color: AppTheme.dark_grey, fontSize: 15, letterSpacing: 1, fontWeight: FontWeight.normal);

  static const TextStyle nameInfor = TextStyle(color: AppTheme.dark_grey, fontSize: 20, letterSpacing: 1, fontWeight: FontWeight.w600);
  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: blue1,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: blue1,
          width: 3,
        ));
  }
}
