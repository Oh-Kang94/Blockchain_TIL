import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

class UpdateWalletUsecase
    extends BaseUseCase<WalletEntity, Result<WalletEntity>> {
  final WalletRepository _walletRepository;
  UpdateWalletUsecase(this._walletRepository);

  @override
  FutureOr<Result<WalletEntity>> call(WalletEntity request) =>
      _walletRepository.updateUserInfo(wallet: request);
}
