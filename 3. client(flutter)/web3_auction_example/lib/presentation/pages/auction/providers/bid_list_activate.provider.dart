import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/auction/entities/bid.entity.dart';
import 'package:web3_auction_example/presentation/providers/auction/auction_bidding_arg.provider.dart';

part 'bid_list_activate.provider.g.dart';

@riverpod
class BidListActivate extends _$BidListActivate {
  @override
  FutureOr<List<BidEntity>> build() async {
    int tokenId = ref.read(auctionBiddingArgProvider);
    final Result<List<BidEntity>> result =
        await getAuctionListByTokenUsecase.call(tokenId.toString());
    return result.fold(
      onSuccess: (value) => value,
      onFailure: (e) => throw e,
    );
  }

  // TODO : Need To Impl update from Node for updated price
}
