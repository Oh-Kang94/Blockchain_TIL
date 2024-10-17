import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_color.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/pages/splash/splash.event.dart';

class SplashPage extends BasePage with SplashEvent {
  const SplashPage({super.key});

  @override
  void onInit(WidgetRef ref) {
    routeByUserAuth(ref);
  }

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Center(
      child: Icon(
        Icons.wallet,
        color: AppColor.of.primary,
      ),
    );
  }
}
