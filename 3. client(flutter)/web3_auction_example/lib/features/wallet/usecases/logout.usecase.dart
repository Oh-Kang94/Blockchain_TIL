import 'dart:async';

import 'package:web3_auction_example/core/modules/result/exception.dart';
import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

class LogoutUsecase extends BaseNoParamUseCase<Result<void>> {
  final WalletRepository _repository;

  LogoutUsecase(this._repository);

  @override
  FutureOr<Result<void>> call() async {
    final wallet = (await _repository.getActivateWallet()).getOrThrow();
    final result = await _repository.deActivateWallet(
      activatedWallet: wallet.copyWith(isActivate: false),
    );
    
    return result.fold(
      onSuccess: (value) => Result.success(null),
      onFailure: (e) => Result.failure(const DatabaseException()),
    );
  }
}
