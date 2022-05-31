import 'package:flutter/material.dart';
import 'package:ACI/utils/values/app_colors.dart';

///App Styles Class -> Resource class for storing app level styles constants
class AppStyles {
  //light Theme
  static ThemeData lightTheme(BuildContext context) {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
        primaryColor: AppColors.PRIMARY_COLOR,
        primaryColorDark: AppColors.PRIMARY_COLOR_DARK,
        primaryColorLight: AppColors.PRIMARY_COLOR_LIGHT,
        accentColor: AppColors.ACCENT_COLOR,
        textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Open Sans',/*
            bodyColor: Colors.white,
            displayColor: Colors.white*/));

  }
}
