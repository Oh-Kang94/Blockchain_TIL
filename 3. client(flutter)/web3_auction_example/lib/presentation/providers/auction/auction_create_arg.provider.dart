import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/router/routes.dart';

part 'auction_create_arg.provider.g.dart';

@riverpod
int auctionCreateArg(AuctionCreateArgRef ref) {
  return AuctionCreateRoute.tokenIdArg;
}
