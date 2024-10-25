import 'dart:async';

import 'package:web3_auction_example/core/modules/result/result.dart';
import 'package:web3_auction_example/core/modules/usecase/base.usecase.dart';
import 'package:web3_auction_example/features/wallet/entities/wallet.entity.dart';
import 'package:web3_auction_example/features/wallet/repository/wallet.repository.dart';

final class GetWalletListUseCase
    extends BaseNoParamUseCase<Result<List<WalletEntity>>> {
  final WalletRepository _repository;

  GetWalletListUseCase(this._repository);

  @override
  FutureOr<Result<List<WalletEntity>>> call() async {
    final result = await _repository.getWallets();

    // 성공적인 결과일 경우만 필터링 처리
    return result.when(
      success: (wallets) {
        final filteredWallets =
            wallets.where((wallet) => !wallet.isActivate).toList();
        return Result.success(filteredWallets); // 필터링된 결과 반환
      },
      failure: (error) => Result.failure(error), // 에러 처리
    );
  }
}
