import 'package:flutter/material.dart';

class AppTypography {
  static TextStyle bodyBold({Color? color}) => TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle bodySemiBold({Color? color}) => TextStyle(
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headline({Color? color}) => TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
        fontSize: 24,
      );
}
