import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/features/auction/entities/bid.entity.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/bid_list_activate.provider.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/nft_list_auction.provider.dart';
import 'package:web3_auction_example/presentation/providers/auction/auction_bidding_arg.provider.dart';

mixin class AuctionBiddingState {
  AsyncValue<List<BidEntity>> bidListActiveAsync(WidgetRef ref) {
    final bidListActiveAsync = ref.watch(bidListActivateProvider);

    return bidListActiveAsync.when(
      data: (bidList) {
        return AsyncValue.data(
          bidList.reversed.toList(),
        );
      },
      loading: () => const AsyncValue.loading(), // 로딩 중일 때
      error: (err, stack) => AsyncValue.error(err, stack), // 에러가 발생했을 때
    );
  }

  AsyncValue<String> imageUrlAsync(WidgetRef ref) {
    final imageUrlAsync = ref.watch(nftListAuctionProvider);
    final tokenId = ref.read(auctionBiddingArgProvider);
    return imageUrlAsync.when(
      data: (value) {
        final imageUrl = (value.firstWhere(
          (element) => element.tokenId == tokenId,
        )).imageUrl;

        return AsyncData(imageUrl);
      },
      error: (err, stack) => AsyncValue.error(err, stack),
      loading: () => const AsyncValue.loading(),
    );
  }
}
