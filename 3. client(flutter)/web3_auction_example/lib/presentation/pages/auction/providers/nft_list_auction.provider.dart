import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';

part 'nft_list_auction.provider.g.dart';

@riverpod
class NftListAuction extends _$NftListAuction {
  @override
  FutureOr<List<NftEntity>> build() async {
    final nftListData = await getAuctionNftListUseCase.call();

    return nftListData.fold(
      onSuccess: (value) {
        return value;
      },
      onFailure: (e) {
        CLogger.e(e);
        throw e;
      },
    );
  }
}
