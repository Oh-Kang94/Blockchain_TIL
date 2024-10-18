import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

class ActivateWalletUseCase extends BaseUseCase<WalletEntity, Result<void>> {
  final WalletRepository _walletRepository;

  ActivateWalletUseCase(this._walletRepository);

  @override
  FutureOr<Result<void>> call(WalletEntity request) {
    return _walletRepository.activateWallet(wallet: request);
  }
}
