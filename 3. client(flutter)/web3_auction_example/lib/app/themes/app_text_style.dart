import 'package:flutter/material.dart';

abstract class AppTextStyle {
  static TextStyle notoSansRegular(double size, double? height) => TextStyle(
        leadingDistribution: TextLeadingDistribution.even, // 글자를 중앙에 오게 하는 Properties
        letterSpacing: -0.02,
        fontSize: size,
        fontWeight: FontWeight.w400,
        height: height == null ? null : height / size,
      );

  static TextStyle notoSansMedium(double size, double? height) =>
      notoSansRegular(size, height).copyWith(
        fontWeight: FontWeight.w500,
      );

  static TextStyle notoSansSemiBold(double size, double? height) =>
      notoSansRegular(size, height).copyWith(
        fontWeight: FontWeight.w600,
      );

  static TextStyle notoSansBold(double size, double? height) =>
      notoSansRegular(size, height).copyWith(
        fontWeight: FontWeight.w800,
      );

  static final TextStyle highlight = notoSansBold(32, 36);
  static final TextStyle headline1 = notoSansBold(24, 33);
  static final TextStyle headline2 = notoSansBold(20, 27);
  static final TextStyle headline3 = notoSansSemiBold(18, 24);
  static final TextStyle title1 = notoSansBold(16, 22);
  static final TextStyle title2 = notoSansSemiBold(16, 22);
  static final TextStyle title3 = notoSansBold(14, 20);
  static final TextStyle body1 = notoSansSemiBold(14, 20);
  static final TextStyle body2 = notoSansMedium(14, 20);
  static final TextStyle body3 = notoSansMedium(13, 18);
  static final TextStyle alert1 = notoSansSemiBold(12, 17);
  static final TextStyle alert2 = notoSansRegular(12, 17);
}
