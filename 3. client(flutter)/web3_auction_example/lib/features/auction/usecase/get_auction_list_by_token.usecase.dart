import 'dart:async';

import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/auction/entities/bid.entity.dart';
import 'package:web3_auction_example/features/auction/repository/auction.repository.dart';

class GetAuctionListByTokenUsecase
    extends BaseUseCase<String, Result<List<BidEntity>>> {
  final AuctionRepository _auctionRepository;

  GetAuctionListByTokenUsecase(this._auctionRepository);

  @override
  FutureOr<Result<List<BidEntity>>> call(String request) async {
    try {
      final result =
          await _auctionRepository.getBidListByTokenId(tokenId: request);
      return result;
    } catch (e) {
      return Result.failure(UndefinedException(e.toString()));
    }
  }
}
