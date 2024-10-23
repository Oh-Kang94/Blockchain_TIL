import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/nft_list_auction.provider.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/nft_list_own.provider.dart';

mixin AuctionState {
  AsyncValue<List<NftEntity>> nftOwnListAsync(WidgetRef ref) =>
      ref.watch(nftListOwnProvider);
  AsyncValue<List<NftEntity>> nftAuctionListAsync(WidgetRef ref) =>
      ref.watch(nftListAuctionProvider);
}
