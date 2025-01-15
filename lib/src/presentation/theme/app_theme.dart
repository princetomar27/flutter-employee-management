import 'package:flutter/material.dart';

import '../../core/colors/app_colors.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          color: AppColors.textPrimaryColor,
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: TextStyle(
          color: AppColors.textSecondaryColor,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(6),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppColors.primaryColor.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(6),
          gapPadding: 4,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(6),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(6),
        ),
        hintStyle: TextStyle(
          color: Colors.grey[500],
          fontSize: 16.0,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      ),
    );
  }
}
