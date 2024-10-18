import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

final class AuthUsecase extends BaseNoParamUseCase<Result<WalletEntity>> {
  final WalletRepository _repository;

  AuthUsecase(this._repository);

  @override
  FutureOr<Result<WalletEntity>> call() => _repository.getActivateWallet();
}
