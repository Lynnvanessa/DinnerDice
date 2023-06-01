import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData themeData = ThemeData(
    fontFamily: "McLaren",
    primaryColor: AppColors.primary,
    primarySwatch: AppColors.createMaterialColor(AppColors.primary),
    useMaterial3: true,
  );
}
