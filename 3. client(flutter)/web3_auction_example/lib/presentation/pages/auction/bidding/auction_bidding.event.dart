import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';

mixin class AuctionBiddingEvent {
  Future clickBidding(
    WidgetRef ref,
    context, {
    required String biddingPrice,
    required int listingId,
  }) async {
    // #0 : Verification for good Price
    // TODO : Impl for this
    // #1 : call UseCase,
    final result = await bidAuctionUsecase
        .call((biddingPrice: biddingPrice, listingId: listingId));
  }
}
