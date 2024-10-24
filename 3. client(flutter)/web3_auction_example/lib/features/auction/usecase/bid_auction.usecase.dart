import 'dart:async';

import 'package:web3_auction_example/core/extensions/double.extensions.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';

class BidAuctionUsecase
    extends BaseUseCase<({String biddingPrice, int listingId}), Result> {
  final AuctionRepository _auctionRepository;
  BidAuctionUsecase(this._auctionRepository);

  @override
  FutureOr<Result> call(({String biddingPrice, int listingId}) request) {
    try {
      final result = _auctionRepository.bidAuction(
        biddingPrice: double.parse(request.biddingPrice).toBigIntFromEth,
        listingId: BigInt.from(request.listingId),
      );
      return Result.success(result);
    } catch (e) {
      rethrow;
    }
  }
}
