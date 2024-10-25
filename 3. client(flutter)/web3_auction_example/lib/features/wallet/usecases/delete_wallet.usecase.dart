import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

class DeleteWalletUsecase extends BaseUseCase<WalletEntity, Result> {
  final WalletRepository _repository;
  DeleteWalletUsecase(this._repository);
  @override
  FutureOr<Result> call(WalletEntity request) =>
      _repository.deleteWallet(walletEntity: request);
}
