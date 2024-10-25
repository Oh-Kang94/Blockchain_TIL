import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/model/signin.dto.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

final class SignInUseCase extends BaseUseCase<SignInDto, Result<WalletEntity>> {
  final WalletRepository _repository;

  SignInUseCase(this._repository);

  @override
  FutureOr<Result<WalletEntity>> call(SignInDto request) async {
    final result = await _repository.getWalletByPrivateKey(request.privateKey);
    final wallet = result.getOrThrow();
    if (wallet != null) {
      await _repository.activateWallet(
        activatedWallet: wallet.copyWith(isActivate: true),
      );
      return Result.success(wallet);
    }
    return await _repository.createUserInfo(signin: request);
  }
}
