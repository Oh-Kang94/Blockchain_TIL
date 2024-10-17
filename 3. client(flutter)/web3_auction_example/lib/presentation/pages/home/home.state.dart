import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/presentation/providers/nft/nft_list.provider.dart';

mixin HomeState {
  AsyncValue<List<NftEntity>> nftListAsync(WidgetRef ref) =>
      ref.watch(nftListProvider);
}
