import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction.dto.dart';
import 'package:web3_auction_example/features/auction/repository/model/auction_create_event.dto.dart';

abstract class AuctionRepository {
  Future<Result<(AuctionCreateEventDto, BigInt)>> createAuction({
    required AuctionDto auctionDto,
  });
}
