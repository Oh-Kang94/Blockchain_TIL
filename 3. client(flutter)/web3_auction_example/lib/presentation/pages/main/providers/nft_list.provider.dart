import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';

part 'nft_list.provider.g.dart';

@riverpod
class NftList extends _$NftList {
  @override
  FutureOr<List<NftEntity>> build() async {
    final nftListData = await getNftListUseCase.call();
    return nftListData.fold(
      onSuccess: (value) {
        return value;
      },
      onFailure: (e) {
        throw e;
      },
    );
  }
}
