import 'package:flutter/material.dart';

class AppColor extends ThemeExtension<AppColor> {
  // Variables
  final Color white;
  /// Orange
  final Color primary;
  /// Blue
  final Color secondary;
  final Color gray; // gray
  final Color black; // black
  /// Red
  final Color error;
  /// Green
  final Color confirm;

  // Constructor
  AppColor._({
    required this.white,
    required this.primary,
    required this.secondary,
    required this.gray,
    required this.black,
    required this.error,
    required this.confirm,
  });

  // Light
  static final AppColor _light = AppColor._(
    white: Colors.white,
    primary: Colors.orange,
    secondary: Colors.blue,
    gray: Colors.grey,
    black: Colors.black,
    error: Colors.red,
    confirm: Colors.green,
  );
  factory AppColor() => _light;

  // Dark
  static final AppColor _dark = AppColor._(
    white: Colors.white,
    primary: Colors.orange,
    secondary: Colors.blue,
    gray: Colors.grey,
    black: Colors.black,
    error: Colors.red,
    confirm: Colors.green,
  );
  factory AppColor.dark() => _dark;

  static late BuildContext _context;
  static void init(BuildContext context) => _context = context;

  static AppColor get of => Theme.of(_context).extension<AppColor>()!;
  static AppColor? get maybeOf => Theme.of(_context).extension<AppColor>();

  @override
  ThemeExtension<AppColor> copyWith({
    Color? white,
    Color? primary,
    Color? secondary,
    Color? gray,
    Color? black,
    Color? error,
    Color? confirm,
  }) {
    return AppColor._(
      white: white ?? this.white,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      gray: gray ?? this.gray,
      black: black ?? this.black,
      error: error ?? this.error,
      confirm: confirm ?? this.confirm,
    );
  }

  @override
  ThemeExtension<AppColor> lerp(
    covariant ThemeExtension<AppColor>? other,
    double t,
  ) {
    if (other is! AppColor) {
      return this;
    }
    return AppColor._(
      white: Color.lerp(white, other.white, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      gray: Color.lerp(gray, other.gray, t)!,
      black: Color.lerp(black, other.black, t)!,
      error: Color.lerp(error, other.error, t)!,
      confirm: Color.lerp(confirm, other.confirm, t)!,
    );
  }
}
