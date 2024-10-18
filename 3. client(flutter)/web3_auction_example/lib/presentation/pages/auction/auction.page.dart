import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:web3_auction_example/presentation/pages/auction/widgets/auction_listing.tab.dart';
import 'package:web3_auction_example/presentation/pages/auction/widgets/current_auction.tab.dart';
import 'package:web3_auction_example/presentation/pages/base/base_page.dart';

part 'widgets/auction.scaffold.dart';

class AuctionPage extends BasePage {
  const AuctionPage({super.key});

  @override
  Widget buildPage(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    return _Scaffold(
      tabController: tabController,
      auctionListingTab: const AuctionListingTabView(),
      currentAuctionsTab: const CurrentAuctionTabView(),
    );
  }

  @override
  bool get canPop => false;
}
