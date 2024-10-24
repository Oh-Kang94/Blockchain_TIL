import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/auction/entities/bid.entity.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction_create_event.dto.dart';
import 'package:web3_auction_example/features/auction/repository/model/bid_created_event.dto.dart';

abstract class AuctionRepository {
  Future<Result<(AuctionCreateEventDto, BigInt)>> createAuction({
    required AuctionDto auctionDto,
  });

  Future<Result<List<BidEntity>>> getBidListByTokenId({
    required String tokenId,
  });

  Future<Result<(BidCreatedEventDto, BigInt)>> bidAuction({
    required BigInt biddingPrice,
    required BigInt listingId,
  });
}
