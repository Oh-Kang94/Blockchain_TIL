import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web3_auction_example/app/di/modules/locators.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';

part 'wallet_list.provider.g.dart';

@Riverpod(keepAlive: true)
class WalletList extends _$WalletList {
  @override
  FutureOr<List<WalletEntity>> build() async {
    state = const AsyncLoading();
    final result = await getWalletListUseCase.call();
    return result.fold(
      onSuccess: (List<WalletEntity> value) {
        return value;
      },
      onFailure: (Exception e) {
        return [];
      },
    );
  }

  selectForActivate(WalletEntity walletEntity) async {
    state = const AsyncLoading();

    await activateWalletUseCase.call(walletEntity);
    final result = await getWalletListUseCase.call();
    state = result.fold(
      onSuccess: (List<WalletEntity> value) {
        return AsyncData(value);
      },
      onFailure: (Exception e) {
        return AsyncError(e, StackTrace.fromString(''));
      },
    );
  }
}
