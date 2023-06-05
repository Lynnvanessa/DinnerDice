import 'package:flutter/material.dart';

abstract class AppTypography {
  static TextStyle bodyBold({Color? color}) => TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle bodySemiBold({Color? color}) => TextStyle(
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headline({Color? color}) => TextStyle(
        fontWeight: FontWeight.w900,
        color: color,
        fontSize: 22,
      );

  static TextStyle subHeadline({Color? color}) => TextStyle(
        fontWeight: FontWeight.bold,
        color: color,
        fontSize: 18,
      );
}
