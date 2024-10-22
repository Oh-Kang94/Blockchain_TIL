import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/util/logger.dart';
import 'package:web3_auction_example/features/nft/entities/nft.entity.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';

part 'nft_list_own.provider.g.dart';

@riverpod
class NftListOwn extends _$NftListOwn {
  @override
  FutureOr<List<NftEntity>> build() async {
    WalletEntity activateWallet = ref.watch(authProvider).value!.when(
          success: (wallet) => wallet,
          logout: () => throw const DatabaseException(),
          fail: () => throw const DatabaseException(),
        );

    final nftListData = await getOwnNftListUseCase.call(activateWallet.address);

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
