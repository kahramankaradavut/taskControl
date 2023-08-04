import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemeData {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
    brightness: Brightness.light,
    fontFamily: "SourceSansPro",

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightSecondary,
      secondary: AppColors.lightAccent,
      onSecondary: AppColors.lightSecondary,
      error: AppColors.lightError,

      onError: Colors.indigo,
      background: Colors.amber,
      onBackground: Colors.teal,
      surface: Colors.cyan,
      onSurface: Colors.brown,
    ),
    scaffoldBackgroundColor: AppColors.lightSecondary,

    textTheme: const TextTheme(
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFF273469)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.lightPrimary,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.lightPrimary,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.lightInfo,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.lightError,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: AppColors.lightError,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      errorStyle: const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
        color: AppColors.lightError,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      hintStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.lightPrimary.withOpacity(0.4),
      ),
      iconColor: AppColors.lightPrimary,
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(AppColors.lightPrimary),
      checkColor: MaterialStateProperty.all(AppColors.lightSecondary),
      splashRadius: 28,
      side: const BorderSide(color: AppColors.lightPrimary),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),

    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.lightAccent,
      contentTextStyle: TextStyle(color: AppColors.lightBlack)
    ),

    /*textTheme: const TextTheme(
      headline1: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      headline2: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      headline3: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      headline4: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      headline5: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      headline6: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      subtitle1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      subtitle2: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),

      bodyText1: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF273469),
        letterSpacing: 1,
      ),

      bodyText2: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 1,
      ),

      button: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
      ),
    ),*/
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
    brightness: Brightness.dark,
    primarySwatch: const MaterialColor(
      0xFF273469,
      <int, Color>{
        50: Color(0xffF4F5F7),
        100: Color(0xffEAEBF0),
        200: Color(0xffD4D6E1),
        300: Color(0xffBFC3D2),
        400: Color(0xffA9AEC3),
        500: Color(0xff939AB4),
        600: Color(0xff7D85A5),
        700: Color(0xff687196),
        800: Color(0xff525D87),
        900: Color(0xff3D4978)
      },
    ),

    primaryColor: const Color(0xFF273469),
    scaffoldBackgroundColor: const Color(0xffF2F2F2), // +

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(const Color(0xFF273469)),
      splashRadius: 28,
      side: const BorderSide(color: Color(0xFF273469)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        side: const BorderSide(color: Color(0xFF273469)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),

    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      headline2: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      headline3: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      headline4: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      headline5: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headline6: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      subtitle1: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      subtitle2: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      bodyText1: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF273469)),
      bodyText2: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    ),
  );
}