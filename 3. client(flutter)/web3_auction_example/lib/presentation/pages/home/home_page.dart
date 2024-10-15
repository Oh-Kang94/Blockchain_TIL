import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';

class HomePage extends BasePage {
  const HomePage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        "Home Page",
        style: AppTextStyle.title1,
      ),
    );
  }
}
