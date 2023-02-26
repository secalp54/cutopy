import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData lightTheme() {
    return ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
          foregroundColor: AppColor.textColor,
          centerTitle: true,
          elevation: 0,
          color: AppColor.appBarBackColor,
          iconTheme: IconThemeData(color: AppColor.appBarIconColor),
          actionsIconTheme: IconThemeData(color: AppColor.appBarIconColor)),
      floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: AppColor.buttonColor),
      elevatedButtonTheme:
          ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(AppColor.buttonColor))),
      textTheme: TextTheme(
        bodyText1: AppTextStyle.bodyText1,
      ).copyWith(titleMedium: AppTextStyle.titleText, titleLarge: AppTextStyle.appBarTitle),
    );
  }
}

class AppColor {
  static Color buttonColor = const Color.fromARGB(255, 2, 14, 33);
  static Color? textColor = Colors.blueGrey[900];
  static Color? textFormBorderColor = const Color.fromARGB(255, 243, 233, 202);
  static Color? appBarBackColor = Colors.transparent;
  static Color? appBarIconColor = Colors.black;
}

class AppTextStyle {
  static TextStyle bodyText1 = GoogleFonts.nunito(color: AppColor.textColor, fontSize: 16);
  static TextStyle titleText = GoogleFonts.nunito(color: AppColor.textColor, fontSize: 20);
  static TextStyle appBarTitle =
      GoogleFonts.nunito(color: AppColor.textColor, fontSize: 26, fontWeight: FontWeight.bold);
}
