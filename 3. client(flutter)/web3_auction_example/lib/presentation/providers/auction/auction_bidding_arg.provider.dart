import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/router/routes.dart';

part 'auction_bidding_arg.provider.g.dart';

@riverpod
int auctionBiddingArg(AuctionBiddingArgRef ref) {
  return AuctionBiddingRoute.tokenIdArg;
}
