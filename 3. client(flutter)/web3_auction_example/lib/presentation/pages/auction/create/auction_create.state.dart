import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/presentation/pages/auction/providers/nft_list_own.provider.dart';
import 'package:web3_auction_example/presentation/providers/auction/auction_create_arg.provider.dart';

mixin class AuctionCreateState {
  /// NFT Async
  AsyncValue<NftEntity> nftAsync(WidgetRef ref) {
    int tokenId = ref.read(auctionCreateArgProvider);

    final nftListAsync = ref.watch(nftListOwnProvider);

    return nftListAsync.when(
      data: (nftList) {
        return AsyncValue.data(nftList.firstWhere((element) => element.tokenId == tokenId));
      },
      loading: () => const AsyncValue.loading(), // 로딩 중일 때
      error: (err, stack) => AsyncValue.error(err, stack), // 에러가 발생했을 때
    );
  }

  // TextEditingController For Price
  
}
