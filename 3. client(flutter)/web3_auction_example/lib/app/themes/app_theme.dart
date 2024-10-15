import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    extensions: <ThemeExtension<dynamic>>[
      AppColor(),
    ],
  );
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    extensions: <ThemeExtension<dynamic>>[
      AppColor.dark(),
    ],
  );
}
