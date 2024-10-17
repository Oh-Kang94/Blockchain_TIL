import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/themes/app_text_style.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';
import 'package:web3_auction_example/presentation/pages/home/home.state.dart';
import 'package:web3_auction_example/presentation/pages/home/widgets/nft_section.widget.dart';

part 'widgets/home_scaffold.widget.dart';

class HomePage extends BasePage with HomeState {
  const HomePage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    return const _Scaffold(
      nftList: NftSection(),
    );
  }
}
