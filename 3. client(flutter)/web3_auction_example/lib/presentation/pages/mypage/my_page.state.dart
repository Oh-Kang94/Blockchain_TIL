import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/presentation/providers/wallet/auth.provider.dart';
import 'package:web3_auction_example/presentation/providers/wallet/wallet_list.provider.dart';

mixin class MyPageState {
  ///
  /// Wallet List
  ///
  AsyncValue<List<WalletEntity>> walletListAsync(WidgetRef ref) =>
      ref.watch(walletListProvider);

  ///
  /// Activate Wallet
  ///
  AsyncValue<WalletEntity> activatedWalletAsync(WidgetRef ref) {
    return ref.watch(authProvider).whenData(
          (AuthState value) => value.when(
            success: (wallet) => wallet,
            logout: () => throw UndefinedException,
            fail: () => throw UndefinedException,
          ),
        );
  }
}
