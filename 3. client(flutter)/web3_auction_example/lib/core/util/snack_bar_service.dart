import 'package:flutter/material.dart';
import 'package:web3_auction_example/app/router/router.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';

abstract class SnackBarService {
  SnackBarService._();

  static void showSnackBar(String text) {
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!)
        .hideCurrentSnackBar();
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).clearSnackBars();
    ScaffoldMessenger.of(rootNavigatorKey.currentContext!).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 800),
        content: Text(
          text,
          style: AppTextStyle.alert2.copyWith(
            color: AppColor.of.white,
          ),
        ),
      ),
    );
  }
}
