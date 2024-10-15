import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';

class Home extends BasePage {
  const Home({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text("Hello"),
    );
  }
}
