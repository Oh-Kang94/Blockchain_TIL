import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/presentation/pages/auction/auction.state.dart';

class CurrentAuctionTabView extends HookConsumerWidget with AuctionState {
  const CurrentAuctionTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        "경매 리스트 보기",
      ),
    );
  }
}
