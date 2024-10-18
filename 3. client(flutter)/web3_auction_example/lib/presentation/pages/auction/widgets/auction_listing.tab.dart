import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/pages/auction/auction.state.dart';
import 'package:web3_auction_example/presentation/widgets/common/nft_section.widget.dart';

class AuctionListingTabView extends HookConsumerWidget with AuctionState{
  const AuctionListingTabView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: NftSection(
        nftList: nftListAsync(ref),
      ),
    );
  }
}